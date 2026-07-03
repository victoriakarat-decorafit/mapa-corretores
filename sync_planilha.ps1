# =============================================================================
# sync_planilha.ps1
#
# Le a planilha do Google Sheets (colunas: Nome, Endereco, Telefone, Status,
# Observacao), compara com o que ja existe no mapa (locations.json) e:
#   - adiciona enderecos novos (geocodificando via Nominatim para achar bairro/lat/lng)
#   - atualiza o status (visitado / a visitar) de enderecos que ja existem, se mudou
#   - atualiza telefone/observacao se vierem preenchidos e diferentes
#
# Se a planilha tiver mais de uma linha para o mesmo endereco (ex: log de
# eventos), a ULTIMA linha da planilha para aquele endereco eh a que vale.
#
# Depois regenera o array `const locations = [...]` dentro de mapa.html a partir
# do locations.json atualizado, e sincroniza index.html (copia publicada no
# GitHub Pages).
#
# Uso:
#   .\sync_planilha.ps1
#   .\sync_planilha.ps1 -DryRun     # so mostra o que mudaria, nao salva nada
# =============================================================================

param(
    [string]$SheetCsvUrl = "https://docs.google.com/spreadsheets/d/1TWfdOMYQHQiOKDAkNwhfeGNjRymLw-umGL3K0fMgnkw/export?format=csv&gid=133335340",
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"
$root      = Split-Path -Parent $MyInvocation.MyCommand.Path
$mapaPath  = Join-Path $root "mapa.html"
$indexPath = Join-Path $root "index.html"
$jsonPath  = Join-Path $root "locations.json"
$userAgent = "MapaCorretores/1.0 victoria.karat@decorafit.com.br"

# Mapeamento de status da planilha -> explored (true = visitado / laranja, false = a visitar / azul)
# Ajuste aqui se novos valores de status forem usados na planilha.
$STATUS_MAP = @{
    "visitado"  = $true
    "a visitar" = $false
}

function Normalize-Text($s) {
    if (-not $s) { return "" }
    $t = $s.ToLower()
    $t = $t -replace "[áàâã]", "a" -replace "[éèê]", "e" -replace "[íìî]", "i" `
             -replace "[óòôõ]", "o" -replace "[úùû]", "u" -replace "ç", "c"
    $t = $t -replace "^r\.?\s+", "rua " -replace "^av\.?\s+", "avenida " -replace "^al\.?\s+", "alameda "
    $t = $t -replace "[^a-z0-9]+", " "
    return $t.Trim()
}

function Get-Explored($status) {
    $key = $status.Trim().ToLower()
    if ($STATUS_MAP.ContainsKey($key)) { return $STATUS_MAP[$key] }
    Write-Warning "Status desconhecido '$status' -> assumindo 'a visitar' (explored:false)."
    return $false
}

function Get-Field($row, [string[]]$names) {
    foreach ($n in $names) {
        $prop = $row.PSObject.Properties | Where-Object { $_.Name.Trim().ToLower() -eq $n } | Select-Object -First 1
        if ($prop -and $prop.Value) { return $prop.Value.Trim() }
    }
    return ""
}

# -- 1. Baixar planilha ------------------------------------------------------
Write-Host "Baixando planilha..."
$wc = New-Object System.Net.WebClient
$wc.Encoding = [System.Text.Encoding]::UTF8
$csvRaw = $wc.DownloadString($SheetCsvUrl)
$sheetRows = $csvRaw | ConvertFrom-Csv

if (-not $sheetRows -or $sheetRows.Count -eq 0) {
    throw "Planilha vazia ou nao foi possivel ler."
}
Write-Host "$($sheetRows.Count) linhas lidas da planilha."

# -- 2. Carregar base atual ---------------------------------------------------
$current = Get-Content $jsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
$currentList = [System.Collections.Generic.List[object]]::new()
foreach ($c in $current) { $currentList.Add($c) }

$indexByAddr = @{}
foreach ($c in $currentList) {
    $indexByAddr[(Normalize-Text $c.address)] = $c
}

$added   = @()
$updated = @()
$failed  = @()

foreach ($row in $sheetRows) {
    $nome     = Get-Field $row @("nome")
    $endereco = Get-Field $row @("endereço","endereco")
    $telefone = Get-Field $row @("telefone")
    $status   = Get-Field $row @("status")
    $obs      = Get-Field $row @("observação","observacao")

    if (-not $endereco) { continue }
    if (-not $nome) { $nome = $endereco }
    $key = Normalize-Text $endereco
    $explored = Get-Explored $status

    if ($indexByAddr.ContainsKey($key)) {
        $existing = $indexByAddr[$key]
        $changed = $false
        if ($existing.explored -ne $explored) {
            Write-Host "STATUS: '$($existing.name)' -> $(if($explored){'Visitado'}else{'A visitar'})"
            $existing.explored = $explored
            $changed = $true
        }
        if ($telefone -and $existing.tel -ne $telefone) { $existing.tel = $telefone; $changed = $true }
        if ($obs -and $existing.note -ne $obs) { $existing.note = $obs; $changed = $true }
        if ($changed -and ($updated -notcontains $existing)) { $updated += $existing }
    } else {
        Write-Host "NOVO: $nome | $endereco (geocodificando...)"
        try {
            $resp = Invoke-RestMethod -Uri "https://nominatim.openstreetmap.org/search" `
                -Body @{ q = "$endereco, Sao Paulo, SP, Brasil"; format = "json"; limit = 1; countrycodes = "br"; addressdetails = 1 } `
                -Headers @{ "User-Agent" = $userAgent } -Method Get
            Start-Sleep -Milliseconds 1200

            if ($resp.Count -gt 0) {
                $addr = $resp[0].address
                $bairro = $addr.suburb
                if (-not $bairro) { $bairro = $addr.neighbourhood }
                if (-not $bairro) { $bairro = $addr.city_district }
                if (-not $bairro) { $bairro = "" }

                $new = [PSCustomObject]@{
                    name     = $nome
                    address  = $endereco
                    bairro   = $bairro
                    tel      = $telefone
                    note     = $obs
                    lat      = [double]$resp[0].lat
                    lng      = [double]$resp[0].lon
                    explored = $explored
                }
                $currentList.Add($new)
                $indexByAddr[$key] = $new
                $added += $new
            } else {
                Write-Warning "Nao encontrado no geocoder: $endereco"
                $failed += "$nome | $endereco"
            }
        } catch {
            Write-Warning "Erro ao geocodificar '$endereco': $_"
            $failed += "$nome | $endereco"
        }
    }
}

Write-Host ""
Write-Host "Resumo: $($added.Count) novo(s), $($updated.Count) atualizado(s), $($failed.Count) falha(s)."
if ($failed.Count -gt 0) {
    Write-Host "Enderecos que falharam na geocodificacao (nao foram adicionados):"
    $failed | ForEach-Object { Write-Host "  - $_" }
}

if ($DryRun) {
    Write-Host ""
    Write-Host "Modo DryRun: nada foi salvo. Rode sem -DryRun para aplicar as mudancas."
    exit 0
}

if ($added.Count -eq 0 -and $updated.Count -eq 0) {
    Write-Host "Nada mudou. mapa.html/index.html/locations.json nao foram tocados."
    exit 0
}

# -- 3. Salvar locations.json -------------------------------------------------
$currentList | ConvertTo-Json -Depth 3 | Out-File $jsonPath -Encoding utf8

# -- 4. Regenerar o array `const locations = [...]` dentro de mapa.html -----
function JsEscape($s) {
    if (-not $s) { return "" }
    return $s.Replace('\', '\\').Replace('"', '\"')
}

function Format-Entry($e) {
    $fields = @()
    $fields += "name:`"$(JsEscape $e.name)`""
    $fields += "address:`"$(JsEscape $e.address)`""
    $fields += "bairro:`"$(JsEscape $e.bairro)`""
    $fields += "tel:`"$(JsEscape $e.tel)`""
    if ($e.note) { $fields += "note:`"$(JsEscape $e.note)`"" }
    $fields += "lat:$($e.lat)"
    $fields += "lng:$($e.lng)"
    $fields += "explored:$(if($e.explored){'true'}else{'false'})"
    return "  {" + ($fields -join ", ") + "},"
}

$naoVisitados = $currentList | Where-Object { -not $_.explored } | Sort-Object bairro, name
$visitados    = $currentList | Where-Object { $_.explored } | Sort-Object bairro, name

$lines = @()
$lines += "const locations = ["
$lastBairro = $null
foreach ($e in $naoVisitados) {
    if ($e.bairro -ne $lastBairro) {
        $lines += "  // $($e.bairro.ToUpper())"
        $lastBairro = $e.bairro
    }
    $lines += (Format-Entry $e)
}
if ($visitados.Count -gt 0) {
    $lines += "  // VISITADOS -----------------------------------------------------------------"
    foreach ($e in $visitados) {
        $lines += (Format-Entry $e)
    }
}
# remove a virgula da ultima linha
$lastIdx = $lines.Count - 1
$lines[$lastIdx] = $lines[$lastIdx].TrimEnd(',')
$lines += "];"

$newBlock = $lines -join "`r`n"

$mapaContent = Get-Content $mapaPath -Raw -Encoding UTF8
$pattern = "(?s)const locations = \[.*?\];"
if ($mapaContent -notmatch $pattern) {
    throw "Nao encontrei o array 'const locations = [...]' em mapa.html. Nada foi alterado no HTML (locations.json ja foi atualizado)."
}
$mapaContent = [regex]::Replace($mapaContent, $pattern, [System.Text.RegularExpressions.MatchEvaluator]{ param($m) $newBlock }, 1)
Set-Content -Path $mapaPath -Value $mapaContent -Encoding utf8 -NoNewline

# -- 5. Sincronizar index.html (copia publicada no GitHub Pages) ------------
Copy-Item $mapaPath $indexPath -Force

Write-Host ""
Write-Host "mapa.html, index.html e locations.json atualizados."
Write-Host "Total de pontos no mapa: $($currentList.Count) ($($naoVisitados.Count) a visitar, $($visitados.Count) visitados)."

# -- 6. Avisar sobre bairros novos sem zona mapeada em BAIRRO_TO_ZONE --------
$zoneBlock = [regex]::Match($mapaContent, "(?s)const BAIRRO_TO_ZONE = \{.*?\}").Value
$bairrosUsados = ($currentList | ForEach-Object { $_.bairro } | Where-Object { $_ } | Sort-Object -Unique)
$semZona = $bairrosUsados | Where-Object { $zoneBlock -notmatch [regex]::Escape("`"$_`"") }
if ($semZona.Count -gt 0) {
    Write-Host ""
    Write-Warning "Bairro(s) sem zona mapeada em BAIRRO_TO_ZONE (pins so aparecem na aba 'Todos'): $($semZona -join ', ')"
    Write-Warning "Adicione manualmente em mapa.html -> const BAIRRO_TO_ZONE = { ... }"
}

