# Nahuel Berneri — Personal site (static build)

A clean static rebuild of nahuelberneri.com, ready to deploy on **Cloudflare Pages** for free.

## What's in here

```
index.html        — homepage with the 35-piece works grid
about.html        — about page
contact.html      — contact page
styles.css        — single stylesheet for all three pages
download_images.sh — script to grab local copies of the images (run from your own machine)
```

No build step. No JavaScript framework. Just three HTML files and one stylesheet. Total weight under 50 KB without images.

## A note on the images

The HTML currently points the `<img src="...">` tags at your existing **Squarespace CDN** (`images.squarespace-cdn.com/...`). This means:

- **Right now:** the new site looks correct because Squarespace is still serving the images.
- **If you cancel Squarespace before swapping in local images:** the images will go dark.

To fix this, run the included `download_images.sh` script from your own computer (not from this Claude environment — Anthropic's sandbox blocks the Squarespace CDN, which is why I couldn't download them for you). Then run the find-and-replace step described in **Step 2** below.

---

## Deployment — Cloudflare Pages

### Step 1 — Deploy as-is (5 minutes)

The fastest path. Your site goes live with images still hot-linked to Squarespace.

1. Go to **https://dash.cloudflare.com/** → sign up / log in (free).
2. Left sidebar → **Workers & Pages** → **Create** → **Pages** tab → **Upload assets**.
3. Give the project a name (e.g. `nahuelberneri`).
4. Drag the `site/` folder (the one containing `index.html`) into the upload area, or zip its contents and upload the zip.
5. Click **Deploy site**. You'll get a URL like `nahuelberneri.pages.dev` within ~30 seconds.
6. Open it. Confirm everything looks right.

### Step 2 — Switch images to local copies

Do this **before** cancelling Squarespace.

1. On your computer, open Terminal and `cd` into this `site` folder.
2. Run: `bash download_images.sh` — this saves all 36 images to `./images/`.
3. Run this find-and-replace to point the HTML at the local copies:

```bash
# macOS:
sed -i '' -E 's|https://images\.squarespace-cdn\.com/content/v1/60d486c798123c222749faf7/[^"]*/([^/"]+)|images/\1|g' index.html about.html
```

   Then manually verify with: `grep squarespace-cdn index.html about.html` — should return nothing.

   *(The script-style replacement is approximate. The cleaner approach is the manual list in `image_map.txt` — see below.)*

4. Re-upload the folder to Cloudflare Pages (same project → **Create deployment** → drag folder).

### Step 3 — Custom domain

If you want to keep `nahuelberneri.com`:

1. In Cloudflare Pages → your project → **Custom domains** → **Set up a custom domain** → enter `nahuelberneri.com`.
2. Cloudflare will tell you the DNS records you need. If your domain registrar is Squarespace, log in there → Domains → DNS settings → add the records Cloudflare gave you (or transfer the domain to Cloudflare to manage in one place).
3. SSL is automatic.
4. Once DNS propagates (minutes to a few hours), your domain points at the new site. Cancel Squarespace at that point.

### Step 4 — Cancel Squarespace

Only after Step 3 is verified working. Squarespace cancellation: log in → Account → Billing → Subscriptions → cancel.

---

## Image filename mapping (for manual replacement if needed)

If you'd rather rename the downloaded files to match what's already in the HTML, here's the map. The `download_images.sh` script already names them this way.

| Local filename               | Squarespace original                                          |
| ---                          | ---                                                           |
| `nahuelberneri.jpg`          | `nahuelberneri.jpg` (hero portrait)                           |
| `elonmaster.jpg`             | `sddefault.jpg` (Elon Song)                                   |
| `robynregan.jpg`             | `Screen+Shot+2023-01-23+at+09.51.47.jpg` (Robyn Regan)        |
| `analogmixer.jpeg`           | `analogmixer.jpeg` (London 2021)                              |
| `donna.jpeg`                 | `donna.jpeg`                                                  |
| `implosion.jpeg`             | `123099598_…_n.jpeg`                                          |
| `sedal.jpeg`                 | `lali+verano+sedal.jpeg`                                      |
| `airelibre.jpeg`             | `aire+libre.jpeg`                                             |
| `iris.jpeg`                  | `iris.jpeg`                                                   |
| `alanis.jpg`                 | `alanis.jpg`                                                  |
| `zeta.jpeg`                  | `zeta.jpeg`                                                   |
| `pinoeuropeo.jpeg`           | `pinoeuropeo.jpeg`                                            |
| `bandalos.jpeg`              | `bandalos.jpeg`                                               |
| `coroqom.jpeg`               | `coro-chelalapi-aniv.jpeg`                                    |
| `sofiaperota.jpeg`           | `sofiaperota.jpeg`                                            |
| `cutaia.jpg`                 | `cutaia.jpg`                                                  |
| `efd.jpeg`                   | `efd.jpeg`                                                    |
| `maderasur.jpeg`             | `madera+sur.jpeg`                                             |
| `pikun.jpeg`                 | `pikun.jpeg`                                                  |
| `pushit.jpeg`                | `pushit.jpeg`                                                 |
| `tormentos.jpg`              | `tormentos.jpg`                                               |
| `nicola.jpeg`                | `nicolacuarentena.jpeg`                                       |
| `florayfauna.jpg`            | `florayfauna.jpg`                                             |
| `francisca.jpeg`             | `francisca.jpeg`                                              |
| `maderfanker.jpeg`           | `maderfanker.jpeg`                                            |
| `izabella.jpg`               | `izabella+sudaca.jpg`                                         |
| `sanbomba.jpeg`              | `sanbomba.jpeg`                                               |
| `cvlos.jpg`                  | `Screen+Shot+2021-06-28+at+00.13.17.jpg`                      |
| `against.jpeg`               | `against.jpeg`                                                |
| `luthero.jpeg`               | `luthero.jpeg`                                                |
| `ampher.jpeg`                | `ampher.jpeg`                                                 |
| `venecianos.jpeg`            | `venecianos.jpeg`                                             |
| `maxaguirre.jpeg`            | `max+aguirre.jpeg`                                            |
| `paodebonis.jpeg`            | `paodebonis.jpeg`                                             |
| `pasajeroluminoso.jpg`       | `bKOFx2_NY4Ihq.jpg`                                           |
| `about.jpg`                  | `60718083_…_n.jpg` (about page photo)                         |

---

## Editing the site later

- **Add or remove a project:** open `index.html`, find the `<!-- WORKS -->` section, copy/paste an `<a class="card">…</a>` block. Set `class="card-feat"` to make a piece span double width.
- **Change colours/fonts:** all design tokens are at the top of `styles.css` under `:root`.
- **Re-deploy:** drag the updated folder into Cloudflare Pages again.

If you want a CMS-like editing experience later (so you don't hand-edit HTML), tools like **Decap CMS** or moving to **Eleventy** with a markdown-driven setup are good free upgrades — but plain HTML is honestly fine for a portfolio you update a few times a year.

---

## Costs

- Cloudflare Pages: **£0/month** (free tier includes 500 builds/month, unlimited bandwidth, unlimited sites).
- Domain (`nahuelberneri.com`): whatever you currently pay your registrar — typically **£10–15/year**. If transferred to Cloudflare Registrar, it's near at-cost (~£8/year for `.com`).
- **Total: roughly £10/year vs. Squarespace's ~£200+/year.**
