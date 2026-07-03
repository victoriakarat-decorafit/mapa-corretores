#!/usr/bin/env python3
# -----------------------------------------------------------------------------
# sync_planilha.py
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
# do locations.json atualizado, sincroniza index.html (copia publicada no
# GitHub Pages), e publica tudo no GitHub (commit + push) sozinho.
#
# Uso:
#   python sync_planilha.py
#   python sync_planilha.py --dry-run     # so mostra o que mudaria, nao salva nada
# -----------------------------------------------------------------------------

import csv
import io
import json
import re
import subprocess
import sys
import time
import urllib.parse
import urllib.request
from pathlib import Path

SHEET_CSV_URL = "https://docs.google.com/spreadsheets/d/1TWfdOMYQHQiOKDAkNwhfeGNjRymLw-umGL3K0fMgnkw/export?format=csv&gid=133335340"
USER_AGENT = "MapaCorretores/1.0 victoria.karat@decorafit.com.br"
GITHUB_PAGES_URL = "https://victoriakarat-decorafit.github.io/mapa-corretores/"
GITHUB_RUNS_API = "https://api.github.com/repos/victoriakarat-decorafit/mapa-corretores/actions/runs?per_page=5"

ROOT = Path(__file__).resolve().parent
MAPA_PATH = ROOT / "mapa.html"
INDEX_PATH = ROOT / "index.html"
JSON_PATH = ROOT / "locations.json"

# Mapeamento de status da planilha -> explored (true = visitado / laranja, false = a visitar / azul)
# Ajuste aqui se novos valores de status forem usados na planilha.
STATUS_MAP = {
    "visitado": True,
    "a visitar": False,
}

ACCENTS = str.maketrans("áàâãéèêíìîóòôõúùûç", "aaaaeeeiiioooouuuc")


def normalize_text(s):
    if not s:
        return ""
    t = s.lower().translate(ACCENTS)
    t = re.sub(r"^r\.?\s+", "rua ", t)
    t = re.sub(r"^av\.?\s+", "avenida ", t)
    t = re.sub(r"^al\.?\s+", "alameda ", t)
    t = re.sub(r"[^a-z0-9]+", " ", t)
    return t.strip()


def get_explored(status):
    key = (status or "").strip().lower()
    if key in STATUS_MAP:
        return STATUS_MAP[key]
    print(f"AVISO: Status desconhecido '{status}' -> assumindo 'a visitar' (explored:false).")
    return False


def get_field(row, names):
    lower_row = {k.strip().lower(): v for k, v in row.items() if k}
    for n in names:
        v = lower_row.get(n)
        if v and v.strip():
            return v.strip()
    return ""


def http_get(url, headers=None):
    req = urllib.request.Request(url, headers=headers or {"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=20) as resp:
        return resp.read().decode("utf-8")


def download_sheet(url):
    print("Baixando planilha...")
    raw = http_get(url)
    rows = list(csv.DictReader(io.StringIO(raw)))
    if not rows:
        raise RuntimeError("Planilha vazia ou nao foi possivel ler.")
    print(f"{len(rows)} linhas lidas da planilha.")
    return rows


def geocode(endereco):
    query = f"{endereco}, Sao Paulo, SP, Brasil"
    params = {
        "q": query,
        "format": "json",
        "limit": 1,
        "countrycodes": "br",
        "addressdetails": 1,
    }
    url = "https://nominatim.openstreetmap.org/search?" + urllib.parse.urlencode(params)
    data = json.loads(http_get(url))
    time.sleep(1.2)
    if not data:
        return None
    item = data[0]
    addr = item.get("address", {})
    bairro = addr.get("suburb") or addr.get("neighbourhood") or addr.get("city_district") or ""
    return {"lat": float(item["lat"]), "lng": float(item["lon"]), "bairro": bairro}


def js_escape(s):
    if not s:
        return ""
    return s.replace("\\", "\\\\").replace('"', '\\"')


def format_entry(e):
    fields = [
        f'name:"{js_escape(e["name"])}"',
        f'address:"{js_escape(e["address"])}"',
        f'bairro:"{js_escape(e["bairro"])}"',
        f'tel:"{js_escape(e.get("tel", ""))}"',
    ]
    if e.get("note"):
        fields.append(f'note:"{js_escape(e["note"])}"')
    fields.append(f'lat:{e["lat"]}')
    fields.append(f'lng:{e["lng"]}')
    fields.append(f'explored:{"true" if e["explored"] else "false"}')
    return "  {" + ", ".join(fields) + "},"


def regenerate_locations_block(current_list):
    nao_visitados = sorted((e for e in current_list if not e["explored"]), key=lambda e: (e["bairro"], e["name"]))
    visitados = sorted((e for e in current_list if e["explored"]), key=lambda e: (e["bairro"], e["name"]))

    lines = ["const locations = ["]
    last_bairro = None
    for e in nao_visitados:
        if e["bairro"] != last_bairro:
            lines.append(f'  // {e["bairro"].upper()}')
            last_bairro = e["bairro"]
        lines.append(format_entry(e))

    if visitados:
        lines.append("  // VISITADOS -----------------------------------------------------------------")
        for e in visitados:
            lines.append(format_entry(e))

    lines[-1] = lines[-1].rstrip(",")
    lines.append("];")
    return "\n".join(lines), nao_visitados, visitados


def run_git(args, check=True):
    result = subprocess.run(["git"] + args, cwd=ROOT, capture_output=True, text=True)
    if check and result.returncode != 0:
        raise RuntimeError(f"git {' '.join(args)} falhou: {result.stderr.strip()}")
    return result


def publish_to_github(added_count, updated_count):
    print("\nPublicando no GitHub...")
    run_git(["add", "mapa.html", "index.html", "locations.json"])

    partes = []
    if added_count:
        partes.append(f"{added_count} endereco(s) novo(s)")
    if updated_count:
        partes.append(f"{updated_count} status/dado(s) atualizado(s)")
    mensagem = "Sincroniza mapa com a planilha - " + ", ".join(partes)

    commit = run_git(["commit", "-m", mensagem], check=False)
    if commit.returncode != 0:
        print("AVISO: Nada para commitar (ou o commit falhou). Verifique 'git status' manualmente.")
        return

    sha = run_git(["rev-parse", "HEAD"]).stdout.strip()
    push = run_git(["push", "origin", "main"], check=False)
    if push.returncode != 0:
        print("AVISO: O commit foi feito localmente, mas o 'git push' falhou.")
        print("Confira sua conexao/login do git e rode 'git push origin main' manualmente.")
        return

    print("\nEnviado para o GitHub. Aguardando a publicacao do site...")
    deploy_ok = None
    for _ in range(18):
        time.sleep(10)
        try:
            runs = json.loads(http_get(GITHUB_RUNS_API))
            run = next((r for r in runs.get("workflow_runs", []) if r.get("head_sha") == sha), None)
            if run and run.get("status") == "completed":
                deploy_ok = run.get("conclusion") == "success"
                break
        except Exception:
            pass

    if deploy_ok is True:
        print(f"\nMapa publicado com sucesso:\n{GITHUB_PAGES_URL}")
    elif deploy_ok is False:
        print("\nAVISO: O GitHub aceitou o commit mas a publicacao do site falhou (instabilidade do GitHub Pages).")
        print("Rode este script de novo para tentar republicar.")
    else:
        print(f"\nCommit enviado. Nao deu tempo de confirmar a publicacao do site, mas ela deve sair em instantes:\n{GITHUB_PAGES_URL}")


def main():
    dry_run = "--dry-run" in sys.argv

    sheet_rows = download_sheet(SHEET_CSV_URL)

    current_list = json.loads(JSON_PATH.read_text(encoding="utf-8-sig"))
    index_by_addr = {}
    for c in current_list:
        index_by_addr[normalize_text(c["address"])] = c

    added, updated, failed = [], [], []
    updated_ids = set()

    for row in sheet_rows:
        nome = get_field(row, ["nome"])
        endereco = get_field(row, ["endereço", "endereco"])
        telefone = get_field(row, ["telefone"])
        status = get_field(row, ["status"])
        obs = get_field(row, ["observação", "observacao"])

        if not endereco:
            continue
        if not nome:
            nome = endereco
        key = normalize_text(endereco)
        explored = get_explored(status)

        if key in index_by_addr:
            existing = index_by_addr[key]
            changed = False
            if existing["explored"] != explored:
                print(f"STATUS: '{existing['name']}' -> {'Visitado' if explored else 'A visitar'}")
                existing["explored"] = explored
                changed = True
            if telefone and existing.get("tel") != telefone:
                existing["tel"] = telefone
                changed = True
            if obs and existing.get("note") != obs:
                existing["note"] = obs
                changed = True
            if changed and id(existing) not in updated_ids:
                updated.append(existing)
                updated_ids.add(id(existing))
        else:
            print(f"NOVO: {nome} | {endereco} (geocodificando...)")
            try:
                geo = geocode(endereco)
            except Exception as e:
                print(f"AVISO: Erro ao geocodificar '{endereco}': {e}")
                failed.append(f"{nome} | {endereco}")
                continue
            if geo is None:
                print(f"AVISO: Nao encontrado no geocoder: {endereco}")
                failed.append(f"{nome} | {endereco}")
                continue
            new_entry = {
                "name": nome,
                "address": endereco,
                "bairro": geo["bairro"],
                "tel": telefone,
                "note": obs,
                "lat": geo["lat"],
                "lng": geo["lng"],
                "explored": explored,
            }
            current_list.append(new_entry)
            index_by_addr[key] = new_entry
            added.append(new_entry)

    print(f"\nResumo: {len(added)} novo(s), {len(updated)} atualizado(s), {len(failed)} falha(s).")
    if failed:
        print("Enderecos que falharam na geocodificacao (nao foram adicionados):")
        for f in failed:
            print(f"  - {f}")

    if dry_run:
        print("\nModo --dry-run: nada foi salvo. Rode sem essa opcao para aplicar as mudancas.")
        return

    if not added and not updated:
        print("Nada mudou. mapa.html/index.html/locations.json nao foram tocados.")
        return

    JSON_PATH.write_text(json.dumps(current_list, ensure_ascii=False, indent=2), encoding="utf-8", newline="\n")

    new_block, nao_visitados, visitados = regenerate_locations_block(current_list)
    mapa_content = MAPA_PATH.read_text(encoding="utf-8-sig")
    pattern = re.compile(r"const locations = \[.*?\];", re.DOTALL)
    if not pattern.search(mapa_content):
        raise RuntimeError("Nao encontrei o array 'const locations = [...]' em mapa.html. Nada foi alterado no HTML (locations.json ja foi atualizado).")
    mapa_content = pattern.sub(lambda m: new_block, mapa_content, count=1)
    MAPA_PATH.write_text(mapa_content, encoding="utf-8", newline="\n")
    INDEX_PATH.write_text(mapa_content, encoding="utf-8", newline="\n")

    print("\nmapa.html, index.html e locations.json atualizados.")
    print(f"Total de pontos no mapa: {len(current_list)} ({len(nao_visitados)} a visitar, {len(visitados)} visitados).")

    zone_match = re.search(r"const BAIRRO_TO_ZONE = \{.*?\}", mapa_content, re.DOTALL)
    zone_block = zone_match.group(0) if zone_match else ""
    bairros_usados = sorted({e["bairro"] for e in current_list if e["bairro"]})
    sem_zona = [b for b in bairros_usados if f'"{b}"' not in zone_block]
    if sem_zona:
        print(f"\nAVISO: Bairro(s) sem zona mapeada em BAIRRO_TO_ZONE (pins so aparecem na aba 'Todos'): {', '.join(sem_zona)}")
        print("Adicione manualmente em mapa.html -> const BAIRRO_TO_ZONE = { ... }")

    publish_to_github(len(added), len(updated))


if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"\nERRO: {e}")
    input("\nPressione Enter para fechar esta janela...")
