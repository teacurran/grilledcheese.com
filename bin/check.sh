#!/usr/bin/env bash
# Pre-deploy checks for the static site in site/. No network, no secrets.
#
#  1. Every local path the page references exists.
#  2. Nothing is loaded from another origin: no scripts, no stylesheets, no
#     fonts, no remote images. The page is HTML, inline CSS and local images.
#  3. Every <img> carries alt, width and height.
#  4. The app is never linked at a grilledcheese.com URL. The product lives at
#     grilledcheese.app; .com is marketing only.
#  5. The first view stays under the budget: HTML + mark + favicon + the
#     largest hero image a 2x phone would fetch, before any lazy image.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
site="$root/site"
html="$site/index.html"
budget=$((500 * 1024))
fail=0

say() { printf '%s\n' "$*"; }
err() { say "FAIL: $*"; fail=1; }

# 1. Referenced local paths exist.
refs=$(grep -oE '(href|src|srcset|content)="[^"]*"' "$html" \
  | sed -E 's/^[a-z]+="//; s/"$//' \
  | tr ',' '\n' | sed -E 's/^ +//; s/ [0-9]+w$//' \
  | grep -E '^/' | sort -u)
for ref in $refs; do
  [ "$ref" = "/" ] && ref=/index.html
  [ -f "$site$ref" ] || err "missing file for reference $ref"
done

# 2. Nothing from another origin.
if grep -qE '<script|<link[^>]+rel="stylesheet"|@import|url\((https?:)?//|@font-face' "$html"; then
  err "page pulls a script, stylesheet, font or remote URL; it must be self-contained"
fi
if grep -oE '(src|srcset)="[^"]*"' "$html" | grep -qE 'https?://'; then
  err "an image is loaded from another origin"
fi

# 3. Images carry alt, width and height.
grep -oE '<img [^>]*>' "$html" | while read -r tag; do
  for attr in alt width height; do
    case "$tag" in *" $attr="*) ;; *) say "FAIL: <img> without $attr: ${tag:0:80}"; exit 1;; esac
  done
done || fail=1

# 4. No app links on the .com domain.
if grep -oE '(href|src)="[^"]*"' "$html" | grep -E 'grilledcheese\.com/[^"]|[a-z-]+\.grilledcheese\.com' | grep -q .; then
  err "a link points at the app on grilledcheese.com; the app lives at grilledcheese.app"
fi

# 5. First-view weight.
# `wc -c`, not `stat`: the two stats disagree on what -f means and the usual
# `stat -f %z || stat -c %s` fallback is broken rather than portable — on Linux
# the first form SUCCEEDS as "filesystem status" and prints block-device fields,
# so the fallback never runs and the caller compares an integer against
# "Namelen: 255". This ran green on macOS and failed on CI for exactly that.
size() { wc -c < "$1" | tr -d ' '; }
hero=0
for f in "$site"/img/screens/feed-text-{light,dark}-720.{avif,webp}; do
  s=$(size "$f"); [ "$s" -gt "$hero" ] && hero=$s
done
first=$(( $(size "$html") + $(size "$site/img/mark-128.png") + $(size "$site/favicon.ico") + hero ))
say "first view (uncompressed HTML + mark + favicon + largest hero variant): $((first / 1024)) KB"
say "whole site: $(du -sk "$site" | cut -f1) KB"
[ "$first" -lt "$budget" ] || err "first view exceeds the $((budget / 1024)) KB budget"

[ "$fail" -eq 0 ] && say "ok"
exit "$fail"
