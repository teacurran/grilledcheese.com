#!/usr/bin/env bash
# Regenerate site/img/screens/ from screenshots/.
#
# Every PNG in screenshots/ is a raw app viewport (no frame, no copy). For
# each one this writes AVIF and WebP at the two widths the page requests:
# 360 for 1x phones and 720 for 2x displays. Run it after replacing or adding
# a screenshot, then commit the output; the deploy has no build step.
#
# Needs ImageMagick 7 (`magick`) built with AVIF and WebP support.
set -euo pipefail

root="$(cd "$(dirname "$0")/.." && pwd)"
out="$root/site/img/screens"
mkdir -p "$out"

for png in "$root"/screenshots/*.png; do
  name="$(basename "${png%.png}")"
  for w in 360 720; do
    magick "$png" -resize "${w}x" -strip -quality 50 "$out/$name-$w.avif"
    magick "$png" -resize "${w}x" -strip -quality 78 -define webp:method=6 "$out/$name-$w.webp"
  done
  echo "$name: $(magick identify -format '%wx%h' "$png")"
done
