#!/usr/bin/env bash
# -----------------------------------------------------------
# download_images.sh
#
# Run this from your own computer (Mac/Linux). It will:
#   1. Create ./images/ next to the HTML files
#   2. Download all 36 images from your Squarespace CDN
#   3. Patch index.html and about.html to reference the
#      local copies instead of the remote URLs
#
# Usage:
#   chmod +x download_images.sh
#   bash download_images.sh
# -----------------------------------------------------------
set -euo pipefail

cd "$(dirname "$0")"
mkdir -p images

# Each line: local_filename|full_squarespace_url
manifest=(
  "nahuelberneri.jpg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1629728738552-O2XBSKZIQBBRZC6SWQQ2/nahuelberneri.jpg"
  "elonmaster.jpg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1674502845052-JBQHXA3FKOV4935Y60U0/sddefault.jpg"
  "robynregan.jpg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1674467526388-5D0Q5SHMKCB2WIX523JZ/Screen+Shot+2023-01-23+at+09.51.47.jpg"
  "analogmixer.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1652431617262-SM97ERUM2HC1RENR964W/analogmixer.jpeg"
  "donna.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1636031217821-SZGUYQS66D9N2R9W8ASG/donna.jpeg"
  "implosion.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624541741501-XVH9ALIAOA72HD3MYJMB/123099598_108056971105770_6846290202067812680_n.jpeg"
  "sedal.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624542840063-NDW89W9Q0L59BDF40W6C/lali+verano+sedal.jpeg"
  "airelibre.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624544099065-2IZXERSMAQTOTAL2A39T/aire+libre.jpeg"
  "iris.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624544606129-NTU6CP9F298I6YGL4W6V/iris.jpeg"
  "alanis.jpg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624547688870-V040TUN8P449OR5YMZL9/alanis.jpg"
  "zeta.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624546971457-EPQQBDYNWVXQQF2DTRPC/zeta.jpeg"
  "pinoeuropeo.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624548120284-E8ZKW6HODR9BDLYIT4P2/pinoeuropeo.jpeg"
  "bandalos.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624548226309-4EV3P4OHMR39BOGUTB74/bandalos.jpeg"
  "coroqom.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624548583590-96CFDMWL5GRMB2466E4J/coro-chelalapi-aniv.jpeg"
  "sofiaperota.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624549197021-LWIG0QJAV12X3A39HAPV/sofiaperota.jpeg"
  "cutaia.jpg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624549673933-R99JU5EG016K4HB4KLC0/cutaia.jpg"
  "efd.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624550340777-NR58APCDSHWB5MUJ1FI6/efd.jpeg"
  "maderasur.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624550885160-5RS249U8YZ75H45CFKMP/madera+sur.jpeg"
  "pikun.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624551299221-MEANHQ44SXZOM42PV6K9/pikun.jpeg"
  "pushit.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624551922197-38V541S4NDH4RVKQVHY8/pushit.jpeg"
  "tormentos.jpg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624552588533-IFJIZVFAU6M5KO0TLY7K/tormentos.jpg"
  "nicola.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624554347657-8ZIIYEOSJH8R42SK2817/nicolacuarentena.jpeg"
  "florayfauna.jpg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624691454460-Q8GP0SPPLNIWG5VACXM6/florayfauna.jpg"
  "francisca.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624692034571-SKP4XC56T9IUVH2ZVZQT/francisca.jpeg"
  "maderfanker.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624692505257-HM2YBYCLAUTIDGDPUQM3/maderfanker.jpeg"
  "izabella.jpg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624692866471-646QZZQJAPAC4TYGMPIQ/izabella+sudaca.jpg"
  "sanbomba.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624731642008-CPGTFM9C3203V5CXZ5ZR/sanbomba.jpeg"
  "cvlos.jpg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624835659157-2ZGL8MQNOPCJIXO02BWN/Screen+Shot+2021-06-28+at+00.13.17.jpg"
  "against.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1624835803263-ER8VTX11E0THTNIFDDJ3/against.jpeg"
  "luthero.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1625140935481-D7T4JK9903I3FB3LT9KX/luthero.jpeg"
  "ampher.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1625141625976-HUXKSE5KSSLY638PASJX/ampher.jpeg"
  "venecianos.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1625142177322-WR9EFC8QWV5NXDAHA86T/venecianos.jpeg"
  "maxaguirre.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1625144183725-F2ALJU93ZXP8AIDDFRA0/max+aguirre.jpeg"
  "paodebonis.jpeg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1625144824698-XFUHVM7YLN6F7GXVJLGV/paodebonis.jpeg"
  "pasajeroluminoso.jpg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1625145257635-SWCIPP0CWHKG360P6MQQ/bKOFx2_NY4Ihq.jpg"
  "about.jpg|https://images.squarespace-cdn.com/content/v1/60d486c798123c222749faf7/1625150149289-NGRKDI65SC72MGY96FK2/60718083_629566577455102_390609275978492099_n.jpg"
)

echo "Downloading 36 images into ./images/ …"
ok=0; fail=0
pushd images > /dev/null
for entry in "${manifest[@]}"; do
  name="${entry%%|*}"
  url="${entry#*|}"
  if curl -fsSL --max-time 60 -o "$name" "$url"; then
    printf "  ok  %s\n" "$name"; ok=$((ok+1))
  else
    printf "  FAIL %s\n" "$name"; fail=$((fail+1))
  fi
done
popd > /dev/null
echo "Downloaded: $ok  Failed: $fail"

if [ "$fail" -gt 0 ]; then
  echo "Some downloads failed — fix those before continuing."
  exit 1
fi

echo
echo "Patching index.html and about.html to use ./images/ paths …"

# Use python for safe replacement (URLs contain + and other chars that confuse sed)
python3 - "${manifest[@]}" <<'PY'
import sys, pathlib
entries = sys.argv[1:]
for fname in ("index.html", "about.html"):
    p = pathlib.Path(fname)
    if not p.exists():
        continue
    text = p.read_text()
    for e in entries:
        local, url = e.split("|", 1)
        text = text.replace(url, f"images/{local}")
    p.write_text(text)
    print(f"  patched {fname}")
PY

if grep -q "squarespace-cdn" index.html about.html 2>/dev/null; then
  echo
  echo "WARNING: some squarespace-cdn URLs remain in the HTML."
  grep -n squarespace-cdn index.html about.html | head
  exit 1
else
  echo
  echo "All image references now point to ./images/. Site is ready to redeploy."
fi
