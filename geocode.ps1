$userAgent = "MapaCorretores/1.0 victoria.karat@decorafit.com.br"

$entries = @(
    # PINHEIROS
    @{name="Axpe Imoveis";                    address="Rua Aspicuelta, 245";                    bairro="Pinheiros";       tel="(11) 3032-1311"},
    @{name="Madah Imoveis";                   address="Rua Purpurina, 131";                     bairro="Pinheiros";       tel="(11) 3031-6885"},
    @{name="Zimbro Imoveis";                  address="Rua Mourato Coelho, 1261";               bairro="Pinheiros";       tel="(11) 3034-2122"},
    @{name="Next Pinheiros";                  address="Rua Teodoro Sampaio, 2035";              bairro="Pinheiros";       tel="(11) 3062-8000"},
    @{name="Sh Prime Pinheiros";              address="Rua dos Pinheiros, 1140";                bairro="Pinheiros";       tel="(11) 3093-5500"},
    @{name="Lopes Prime Pinheiros";           address="Rua Fradique Coutinho, 1162";            bairro="Pinheiros";       tel="(11) 3039-8000"},
    @{name="Remax Unique";                    address="Rua Cardeal Arcoverde, 1749";            bairro="Pinheiros";       tel="(11) 3031-0100"},
    @{name="Lello Imoveis Pinheiros";         address="Rua dos Pinheiros, 382";                 bairro="Pinheiros";       tel="(11) 3811-1000"},
    @{name="Coelho da Fonseca Pinheiros";     address="Avenida Brigadeiro Faria Lima, 1451";   bairro="Pinheiros";       tel="(11) 3811-2000"},
    @{name="Bamberg Imoveis de Elite";        address="Rua Mourato Coelho, 946";               bairro="Pinheiros";       tel="(11) 3038-1200"},
    @{name="Mello Imoveis Pinheiros";         address="Rua Pinheiros, 642";                    bairro="Pinheiros";       tel="(11) 3081-3311"},
    @{name="Pinheiros S/A";                   address="Rua Artur de Azevedo, 1520";            bairro="Pinheiros";       tel="(11) 3064-9000"},
    # POMPEIA
    @{name="Rocha Cunha Imoveis";             address="Rua Vanderlei, 1555";                   bairro="Pompeia";         tel="(11) 3675-1170"},
    @{name="YK Private";                      address="Rua Venancio Aires, 433";               bairro="Pompeia";         tel="(11) 5026-9329"},
    @{name="Abrahao Imoveis";                 address="Rua Diana, 515";                        bairro="Pompeia";         tel="(11) 3864-1044"},
    @{name="Karisma Imoveis";                 address="Rua Vanderlei, 1493";                   bairro="Pompeia";         tel="(11) 3675-6111"},
    @{name="Local Imoveis Pompeia";           address="Avenida Pompeia, 1289";                 bairro="Pompeia";         tel="(11) 3868-9000"},
    @{name="Sh Prime Pompeia";                address="Avenida Pompeia, 1610";                 bairro="Pompeia";         tel="(11) 3677-1000"},
    @{name="Remax Liberty";                   address="Rua Cotoxo, 611";                       bairro="Pompeia";         tel="(11) 3871-3333"},
    @{name="Lello Pompeia";                   address="Avenida Pompeia, 1825";                 bairro="Pompeia";         tel="(11) 3674-7000"},
    @{name="Lopes One Pompeia";               address="Avenida Pompeia, 954";                  bairro="Pompeia";         tel="(11) 3803-7100"},
    @{name="Imobiliaria Romano";              address="Rua Venancio Aires, 850";               bairro="Pompeia";         tel="(11) 3672-4000"},
    @{name="Pompeia Imoveis";                 address="Avenida Pompeia, 1118";                 bairro="Pompeia";         tel="(11) 3862-2022"},
    @{name="Nova Romano";                     address="Rua Desembargador do Vale, 612";        bairro="Pompeia";         tel="(11) 3873-1011"},
    # PERDIZES
    @{name="Sh Prime Perdizes";               address="Rua Cardoso de Almeida, 1170";          bairro="Perdizes";        tel="(11) 3677-1010"},
    @{name="Lello Imoveis Perdizes";          address="Rua Cardoso de Almeida, 921";           bairro="Perdizes";        tel="(11) 3874-3000"},
    @{name="Lopes Exclusive Perdizes";        address="Rua Tuim, 452";                         bairro="Perdizes";        tel="(11) 3868-8000"},
    @{name="Remax Gold Perdizes";             address="Rua Itapicuru, 345";                    bairro="Perdizes";        tel="(11) 3872-9000"},
    @{name="Coelho da Fonseca Perdizes";      address="Rua Cardoso de Almeida, 1500";          bairro="Perdizes";        tel="(11) 3670-2000"},
    @{name="Mario Biseo Perdizes";            address="Rua Turiassu, 659";                     bairro="Perdizes";        tel="(11) 3871-9200"},
    @{name="Graziella dos Imoveis Perdizes";  address="Rua Doutor Homem de Melo, 450";         bairro="Perdizes";        tel="(11) 3864-5151"},
    @{name="Perdizes Imoveis";                address="Rua Bartira, 412";                      bairro="Perdizes";        tel="(11) 3673-4040"},
    @{name="Century 21 Perdizes";             address="Rua Itapicuru, 730";                    bairro="Perdizes";        tel="(11) 3865-8000"},
    @{name="Imobiliaria Turiassu";            address="Rua Turiassu, 1143";                    bairro="Perdizes";        tel="(11) 3672-5555"},
    @{name="Imoveis Perdizes Alto Padrao";    address="Rua Monte Alegre, 610";                 bairro="Perdizes";        tel="(11) 3862-5000"},
    @{name="Elite Perdizes";                  address="Rua Capital Federal, 215";              bairro="Perdizes";        tel="(11) 3875-1020"},
    # VILA MADALENA
    @{name="Axpe Vila Madalena";              address="Rua Fradique Coutinho, 1395";           bairro="Vila Madalena";   tel="(11) 3032-1311"},
    @{name="Madah Imoveis Vila Madalena";     address="Rua Purpurina, 131";                    bairro="Vila Madalena";   tel="(11) 3031-6885"},
    @{name="Zimbro Vila Madalena";            address="Rua Mourato Coelho, 1261";              bairro="Vila Madalena";   tel="(11) 3034-2122"},
    @{name="Anglo Americana";                 address="Rua Pedroso Alvarenga, 1177";           bairro="Vila Madalena";   tel="(11) 3816-3000"},
    @{name="Remax Destiny";                   address="Rua Harmonia, 810";                     bairro="Vila Madalena";   tel="(11) 3031-5050"},
    @{name="Lopes One Vila Madalena";         address="Rua Heitor Penteado, 1420";             bairro="Vila Madalena";   tel="(11) 3674-8000"},
    @{name="Sh Prime Vila Madalena";          address="Rua Wisard, 415";                       bairro="Vila Madalena";   tel="(11) 3093-5555"},
    @{name="Lello Vila Madalena";             address="Rua Harmonia, 320";                     bairro="Vila Madalena";   tel="(11) 3811-1050"},
    @{name="Vila Madalena Imoveis Premium";   address="Rua Girassol, 612";                     bairro="Vila Madalena";   tel="(11) 3032-9000"},
    @{name="Tarcha Imoveis";                  address="Rua Fradique Coutinho, 1202";           bairro="Vila Madalena";   tel="(11) 3815-4322"},
    @{name="Bossa Nova Sothebys";             address="Rua Estados Unidos, 1152";              bairro="Vila Madalena";   tel="(11) 3061-0000"},
    @{name="Casa Madalena";                   address="Rua Aspicuelta, 340";                   bairro="Vila Madalena";   tel="(11) 3031-4040"},
    # VILA LEOPOLDINA
    @{name="Local Imoveis Leopoldina";        address="Rua Carlos Weber, 1452";               bairro="Vila Leopoldina";  tel="(11) 3646-8000"},
    @{name="Sh Prime Vila Leopoldina";        address="Rua Carlos Weber, 715";                bairro="Vila Leopoldina";  tel="(11) 3648-5000"},
    @{name="Lello Vila Leopoldina";           address="Avenida Imperatriz Leopoldina, 1120";  bairro="Vila Leopoldina";  tel="(11) 3643-4000"},
    @{name="Lopes One Vila Leopoldina";       address="Rua Carlos Weber, 1190";               bairro="Vila Leopoldina";  tel="(11) 3649-7000"},
    @{name="Remax Japi";                      address="Rua Carlos Weber, 532";                bairro="Vila Leopoldina";  tel="(11) 3831-2000"},
    @{name="Coelho da Fonseca Leopoldina";    address="Rua Carlos Weber, 1633";               bairro="Vila Leopoldina";  tel="(11) 3643-2000"},
    @{name="Leopoldina Imoveis";              address="Avenida Imperatriz Leopoldina, 957";   bairro="Vila Leopoldina";  tel="(11) 3831-1011"},
    @{name="Weber Imoveis";                   address="Rua Carlos Weber, 810";                bairro="Vila Leopoldina";  tel="(11) 3641-3030"},
    @{name="Mbras Imoveis Leopoldina";        address="Avenida Brigadeiro Faria Lima, 2012";  bairro="Vila Leopoldina";  tel="(11) 3034-3111"},
    @{name="Nova Opcao Leopoldina";           address="Avenida Imperatriz Leopoldina, 1222";  bairro="Vila Leopoldina";  tel="(11) 3645-1020"},
    @{name="Prime Choice Leopoldina";         address="Rua Clelia, 2200";                     bairro="Vila Leopoldina";  tel="(11) 3832-4000"},
    @{name="Direct Imoveis Leopoldina";       address="Rua Schilling, 412";                   bairro="Vila Leopoldina";  tel="(11) 3641-8080"},
    # ITAIM BIBI
    @{name="Itaim Ville";                     address="Rua Pedroso Alvarenga, 328";           bairro="Itaim Bibi";       tel="(11) 3588-0808"},
    @{name="Mello Imoveis Itaim";             address="Rua Tabapua, 627";                     bairro="Itaim Bibi";       tel="(11) 3167-3311"},
    @{name="Special Properties";              address="Rua Joaquim Floriano, 466";            bairro="Itaim Bibi";       tel="(11) 3168-5000"},
    @{name="Lopes Prime Itaim";               address="Rua Joaquim Floriano, 1060";           bairro="Itaim Bibi";       tel="(11) 3165-8000"},
    @{name="Sh Prime Itaim";                  address="Rua Tabapua, 1125";                    bairro="Itaim Bibi";       tel="(11) 3074-1000"},
    @{name="Coelho da Fonseca Itaim";         address="Rua Pedroso Alvarenga, 900";           bairro="Itaim Bibi";       tel="(11) 3160-2000"},
    @{name="Lello Imoveis Itaim";             address="Rua Pedroso Alvarenga, 513";           bairro="Itaim Bibi";       tel="(11) 3078-3000"},
    @{name="Remax Master";                    address="Rua Tabapua, 1450";                    bairro="Itaim Bibi";       tel="(11) 3071-2020"},
    @{name="Graziella dos Imoveis Itaim";     address="Rua Joaquim Floriano, 871";            bairro="Itaim Bibi";       tel="(11) 3079-5151"},
    @{name="JLL Corporate";                   address="Avenida Brigadeiro Faria Lima, 3477";  bairro="Itaim Bibi";       tel="(11) 3043-6000"},
    @{name="Binswanger Imoveis";              address="Rua Tabapua, 474";                     bairro="Itaim Bibi";       tel="(11) 3073-1000"},
    @{name="Taylor Real Estate";              address="Rua Pedroso Alvarenga, 1245";          bairro="Itaim Bibi";       tel="(11) 3074-2200"},
    # VILA OLIMPIA
    @{name="Vertiza Imoveis";                 address="Rua Casa do Ator, 1117";               bairro="Vila Olimpia";     tel="(11) 94027-7000"},
    @{name="Sh Prime Vila Olimpia";           address="Rua Olimpiadas, 200";                  bairro="Vila Olimpia";     tel="(11) 3045-5000"},
    @{name="Lopes One Vila Olimpia";          address="Rua Ramos Batista, 152";               bairro="Vila Olimpia";     tel="(11) 3049-9000"},
    @{name="Remax Action";                    address="Rua Gomes de Carvalho, 1329";          bairro="Vila Olimpia";     tel="(11) 3845-1010"},
    @{name="Lello Vila Olimpia";              address="Rua Alvorada, 1240";                   bairro="Vila Olimpia";     tel="(11) 3848-2000"},
    @{name="Coelho da Fonseca Faria Lima";    address="Avenida Brigadeiro Faria Lima, 3900";  bairro="Vila Olimpia";     tel="(11) 3160-2000"},
    @{name="Olimpia Casa Imoveis";            address="Rua Casa do Ator, 355";                bairro="Vila Olimpia";     tel="(11) 3842-1020"},
    @{name="Capital Brokers";                 address="Rua Funchal, 418";                     bairro="Vila Olimpia";     tel="(11) 3044-7000"},
    @{name="Prime Vila Olimpia";              address="Avenida Doutor Cardoso de Melo, 1460"; bairro="Vila Olimpia";     tel="(11) 3849-3030"},
    @{name="Mbras Luxo Vila Olimpia";         address="Avenida Brigadeiro Faria Lima, 2012";  bairro="Vila Olimpia";     tel="(11) 3034-3111"},
    @{name="Velo Imoveis";                    address="Rua Beira Rio, 45";                    bairro="Vila Olimpia";     tel="(11) 3044-1515"},
    @{name="Nova Olimpia";                    address="Rua Joao Cachoeira, 1520";             bairro="Vila Olimpia";     tel="(11) 3846-9090"},
    # BELA VISTA
    @{name="Refugios Urbanos Bela Vista";     address="Rua Rio de Janeiro, 358";              bairro="Bela Vista";       tel="(11) 97972-0161"},
    @{name="Cobertura 101";                   address="Rua da Consolacao, 57";                bairro="Bela Vista";       tel="(11) 99313-2615"},
    @{name="Lello Imoveis Bela Vista";        address="Avenida Paulista, 1200";               bairro="Bela Vista";       tel="(11) 3145-2000"},
    @{name="Sh Prime Bela Vista";             address="Avenida Brigadeiro Luis Antonio, 2344";bairro="Bela Vista";       tel="(11) 3149-5000"},
    @{name="Lopes One Paulista";              address="Rua Augusta, 1500";                    bairro="Bela Vista";       tel="(11) 3549-9000"},
    @{name="Remax Central";                   address="Rua Pamplona, 1400";                   bairro="Bela Vista";       tel="(11) 3285-4000"},
    @{name="Bela Vista Imoveis";              address="Rua Treze de Maio, 1430";              bairro="Bela Vista";       tel="(11) 3284-5000"},
    @{name="Imobiliaria Avanhandava";         address="Rua Avanhandava, 258";                 bairro="Bela Vista";       tel="(11) 3255-1011"},
    @{name="SBR Brokers";                     address="Rua Frei Caneca, 558";                 bairro="Bela Vista";       tel="(11) 3151-6000"},
    @{name="Bixiga Imoveis";                  address="Rua Rui Barbosa, 412";                 bairro="Bela Vista";       tel="(11) 3289-2020"},
    @{name="Paulista Prime";                  address="Alameda Santos, 1100";                 bairro="Bela Vista";       tel="(11) 3171-8000"},
    @{name="Get Imoveis Bela Vista";          address="Rua Sao Carlos do Pinhal, 312";        bairro="Bela Vista";       tel="(11) 3266-7070"}
)

$results = @()
$total = $entries.Count
$i = 0

foreach ($e in $entries) {
    $i++
    $query = "$($e.address), Sao Paulo, SP, Brasil"

    try {
        $resp = Invoke-RestMethod -Uri "https://nominatim.openstreetmap.org/search" `
            -Body @{q=$query; format="json"; limit=1; countrycodes="br"} `
            -Headers @{"User-Agent"=$userAgent} `
            -Method Get

        if ($resp.Count -gt 0) {
            $results += [PSCustomObject]@{
                name=$e.name; address=$e.address; bairro=$e.bairro; tel=$e.tel
                lat=[double]$resp[0].lat; lng=[double]$resp[0].lon; found=$true
            }
            Write-Host "[$i/$total] OK: $($e.name)"
        } else {
            $results += [PSCustomObject]@{
                name=$e.name; address=$e.address; bairro=$e.bairro; tel=$e.tel
                lat=0; lng=0; found=$false
            }
            Write-Host "[$i/$total] NAO ENCONTRADO: $($e.name) | $query"
        }
    } catch {
        $results += [PSCustomObject]@{
            name=$e.name; address=$e.address; bairro=$e.bairro; tel=$e.tel
            lat=0; lng=0; found=$false
        }
        Write-Host "[$i/$total] ERRO: $($e.name) | $_"
    }

    if ($i -lt $total) { Start-Sleep -Milliseconds 1200 }
}

$results | ConvertTo-Json -Depth 3 | Out-File "locations.json" -Encoding utf8

$found = ($results | Where-Object { $_.found }).Count
Write-Host ""
Write-Host "Concluido: $found/$total enderecos encontrados."
