# Security

Please report vulnerabilities privately through GitHub's
"Report a vulnerability" button on this repository's Security tab, not in a
public issue.

Before you put a server on the internet:

1. Set `JWT_KEY` to a long random value (`openssl rand -hex 32`).
2. Put the API behind a reverse proxy with TLS and set
   `RUSTDESK_API_GIN_TRUST_PROXY` to the proxy's address. See
   [examples/nginx.conf](examples/nginx.conf).
3. Do not expose port 21114 directly.
4. Change the admin password printed in the logs on first start.
5. Keep the private key in `./data/id_ed25519` off the internet and out of git.
