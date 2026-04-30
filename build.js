const fs = require('fs');
const path = require('path');

const CONTENT_DIR = './content/works';
const OUTPUT_DIR = './works';

const ICON = "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'%3E%3Crect width='32' height='32' fill='%230a0a0a'/%3E%3Ctext x='16' y='22' font-family='serif' font-size='20' fill='%23e8d3a8' text-anchor='middle' font-style='italic'%3En%3C/text%3E%3C/svg%3E";
const FONTS = "https://fonts.googleapis.com/css2?family=Fraunces:ital,opsz,wght@0,9..144,300;0,9..144,400;0,9..144,500;0,9..144,600;1,9..144,300;1,9..144,400&family=JetBrains+Mono:wght@400;500&display=swap";

function parseFrontmatter(raw) {
  const match = raw.match(/^---\n([\s\S]*?)\n---\n([\s\S]*)$/);
  if (!match) return { data: {}, body: raw };
  const data = {};
  match[1].split('\n').forEach(line => {
    const m = line.match(/^(\w+):\s*"?(.*?)"?\s*$/);
    if (m) data[m[1]] = m[2];
  });
  return { data, body: match[2].trim() };
}

function escape(s) {
  return s.replace(/&/g, '&amp;').replace(/</g, '&lt;').replace(/>/g, '&gt;').replace(/"/g, '&quot;');
}

function mediaEmbed(url) {
  if (!url) return '';
  if (url.includes('spotify.com')) {
    const embedUrl = url.replace('open.spotify.com/', 'open.spotify.com/embed/');
    return `
  <section class="work-video">
    <div class="work-video-inner work-video-spotify">
      <iframe src="${embedUrl}" title="Spotify player" frameborder="0" allow="autoplay; clipboard-write; encrypted-media; fullscreen; picture-in-picture" loading="lazy"></iframe>
    </div>
  </section>`;
  }
  const vid = url.split('v=')[1]?.split('&')[0] || url.split('youtu.be/')[1]?.split('?')[0];
  if (!vid) return '';
  return `
  <section class="work-video">
    <div class="work-video-inner">
      <iframe src="https://www.youtube.com/embed/${vid}" title="YouTube video" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen loading="lazy"></iframe>
    </div>
  </section>`;
}

const FOOTER = `<footer class="footer">
  <div class="footer-grid">
    <div>
      <p class="footer-name">Nahuel Berneri</p>
      <p class="footer-role">Sound Engineer &amp; Music Producer</p>
    </div>
    <div>
      <p class="footer-label">Contact</p>
      <p><a href="mailto:nakuberneri@gmail.com">nakuberneri@gmail.com</a></p>
      <p>Tottenham, London N17</p>
    </div>
    <div>
      <p class="footer-label">Elsewhere</p>
      <p><a href="https://soundcloud.com/nahuelberneri" target="_blank" rel="noopener">SoundCloud</a></p>
      <p><a href="https://www.imdb.com/name/nm2054723/" target="_blank" rel="noopener">IMDb</a></p>
      <p><a href="https://www.linkedin.com/in/nahuelberneri/" target="_blank" rel="noopener">LinkedIn</a></p>
      <p><a href="https://www.discogs.com/artist/3159384-Nahuel-Berneri" target="_blank" rel="noopener">Discogs</a></p>
    </div>
  </div>
  <div class="footer-bottom">
    <span>© <span id="year"></span> Nahuel Berneri</span>
    <span>London — at home everywhere</span>
  </div>
</footer>`;

function buildPage({ title, tag, image, youtube, body }) {
  const ht = escape(title);
  const htag = escape(tag);
  return `<!doctype html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width,initial-scale=1">
<title>${ht} — Nahuel Berneri</title>
<meta name="description" content="${escape(body.slice(0, 150))}">
<link rel="icon" href="${ICON}">
<link rel="preconnect" href="https://fonts.googleapis.com">
<link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
<link href="${FONTS}" rel="stylesheet">
<link rel="stylesheet" href="../styles.css">
</head>
<body>

<header class="nav">
  <a href="/" class="brand">
    <span class="brand-mark">N</span>
    <span class="brand-text">
      <span class="brand-name">Nahuel Berneri</span>
      <span class="brand-role">Sound Engineer · Producer</span>
    </span>
  </a>
  <nav class="nav-links">
    <a href="../index.html#works">Works</a>
    <a href="../about.html">About</a>
    <a href="../contact.html">Contact</a>
  </nav>
</header>

<main>
  <section class="work-hero">
    <a href="../index.html#works" class="back-link">← All works</a>
    <p class="eyebrow"><span class="eyebrow-line"></span>${htag}</p>
    <h1>${ht}</h1>
  </section>

${image ? `  <section class="work-image">
    <img src="../images/${image}" alt="${ht}" loading="eager">
  </section>` : ''}

  <section class="work-body">
    <p>${escape(body)}</p>
  </section>
${mediaEmbed(youtube)}
  <section class="endcap">
    <div class="endcap-inner">
      <p class="eyebrow"><span class="eyebrow-line"></span>Let's work together</p>
      <h2>Got a record, score<br>or sound to make?<em>↗</em></h2>
      <p>Open for new productions, mixing &amp; mastering work, and scoring projects in London &amp; remote.</p>
      <a href="../contact.html" class="btn btn-primary btn-large">Start a conversation</a>
    </div>
  </section>
</main>

${FOOTER}

<script>document.getElementById('year').textContent = new Date().getFullYear();</script>
</body>
</html>
`;
}

if (!fs.existsSync(OUTPUT_DIR)) fs.mkdirSync(OUTPUT_DIR);

const files = fs.readdirSync(CONTENT_DIR).filter(f => f.endsWith('.md'));
let count = 0;
for (const file of files) {
  const raw = fs.readFileSync(path.join(CONTENT_DIR, file), 'utf8');
  const { data, body } = parseFrontmatter(raw);
  const slug = file.replace('.md', '');
  const html = buildPage({ ...data, body });
  fs.writeFileSync(path.join(OUTPUT_DIR, `${slug}.html`), html);
  count++;
}
console.log(`Built ${count} pages.`);
