# grilledcheese.com

The marketing site for Grilled Cheese, the federated social network at
[grilledcheese.app](https://grilledcheese.app). This domain is marketing only;
the app itself is never served from, or linked at, a `.com` address.

## The site

`site/` is the document root, exactly as deployed. There is no build step:
one hand-written `site/index.html` with its CSS inline, the image assets under
`site/img/`, and the favicons. It loads no scripts, fonts or third-party
resources, and the first view is budgeted at well under 500 KB so it holds up
on a poor rural connection, which is the product's own north star.

To work on it, edit `site/index.html` and open it through any static server
(`python3 -m http.server -d site 8000`). Absolute paths like `/img/...` need a
server rather than `file://`.

### Screenshots

`screenshots/` holds one PNG per app screen used on the page: the raw app
viewport, no device frame, no headline copy, no background. The page draws the
frame in CSS and sets every headline in HTML, so a screenshot can be replaced
without touching anything else.

```
bin/build-images.sh          # regenerates site/img/screens/ from screenshots/
```

That writes AVIF and WebP at 360 px and 720 px for each screenshot, which is
what the page's `srcset` asks for. Commit the output; the deploy copies files
and nothing more. It needs ImageMagick 7 with AVIF and WebP support
(`brew install imagemagick`).

Every screenshot is 1070 px wide. Heights differ by how the page crops them:
2167 px for one shown from the top down (`.peek`), 2117 px for one hung from
the bottom up (`.hang`, `profile-bluesky-light`), 2337 px for a full screen
(`feed-video-dark`). The `width`/`height` attributes on the matching `<img>` in
`index.html` must be updated if a replacement has different dimensions.

The current set was cut out of the App Store submission images with
`bin/crop-store-screenshots.sh`. Unframed captures from the app should replace
them, and that script can then be deleted.

### Checks

```
bin/check.sh                              # references, origins, alt text, page weight
npx --yes html-validate@9 site/index.html # markup
```

Both run in CI on every push and pull request.

## Deploying

Pushing to `main` runs `.github/workflows/build_and_deploy.yml`, which runs the
checks, brings up a WireGuard tunnel from the runner, and rsyncs `site/` to
`deploy@10.50.0.30:/var/www/sites/grilledcheese.com/`. Cloudflare fronts the
domain and proxies it to that Apache VM through the `k3s_cluster` tunnel (see
`cloudflare-tunnel.tf` in the `vc-ingress` infra repo).

The workflow needs these repository secrets in the `production` environment:
`WIREGUARD_ADDRESS`, `WIREGUARD_PRIVATE_KEY`, `WIREGUARD_PEER_PUBLIC_KEY`,
`WIREGUARD_ENDPOINT`, `WIREGUARD_ALLOWED_IPS`, `DEPLOY_SSH_PRIVATE_KEY`.

To deploy by hand from a machine that can reach the VM:

```
rsync -avz --delete --exclude .DS_Store site/ deploy@10.50.0.30:/var/www/sites/grilledcheese.com/
```

## The rest of this repository

`app/` is the original grilledcheese.com: Perl written in 1998, last updated
in 2001, migrated from Subversion. `Dockerfile`, `docker-compose.yml` and
`apache-config.conf` run it. `infra/` is the Terraform for the old hosting.
`tshirts/` is what it says.
