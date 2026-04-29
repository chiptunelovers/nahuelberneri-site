const GITHUB_AUTH_URL = 'https://github.com/login/oauth/authorize';
const GITHUB_TOKEN_URL = 'https://github.com/login/oauth/access_token';

export default {
  async fetch(request, env) {
    const url = new URL(request.url);

    if (url.pathname === '/api/auth') {
      const params = new URLSearchParams({
        client_id: env.GITHUB_CLIENT_ID,
        redirect_uri: `${url.origin}/api/auth/callback`,
        scope: 'repo,user',
        state: crypto.randomUUID(),
      });
      return Response.redirect(`${GITHUB_AUTH_URL}?${params}`, 302);
    }

    if (url.pathname === '/api/auth/callback') {
      const code = url.searchParams.get('code');
      const res = await fetch(GITHUB_TOKEN_URL, {
        method: 'POST',
        headers: { 'Accept': 'application/json', 'Content-Type': 'application/json' },
        body: JSON.stringify({
          client_id: env.GITHUB_CLIENT_ID,
          client_secret: env.GITHUB_CLIENT_SECRET,
          code,
        }),
      });
      const { access_token: token, error } = await res.json();

      if (error || !token) {
        return new Response(`OAuth error: ${error}`, { status: 400 });
      }

      const html = `<!doctype html><html><body><script>
(function() {
  function cb(e) {
    window.opener.postMessage(
      'authorization:github:success:{"token":"${token}","provider":"github"}',
      e.origin
    );
  }
  window.addEventListener('message', cb, false);
  window.opener.postMessage('authorizing:github', '*');
})();
<\/script></body></html>`;

      return new Response(html, { headers: { 'Content-Type': 'text/html' } });
    }

    return env.ASSETS.fetch(request);
  },
};
