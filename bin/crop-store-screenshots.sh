#!/usr/bin/env bash
# Extract the raw app viewport out of the App Store submission images.
#
# The store images (1290x2796) carry a cream background, a drawn phone frame
# and, on several, headline copy baked into the pixels. The site draws its own
# frame and sets its own headlines, so only the screen area is wanted. This is
# a one-off for the fallback assets; unframed captures from the app replace
# its output directly in screenshots/ and never need it.
#
# Usage: bin/crop-store-screenshots.sh "<dir with en-US-*.png>"
set -euo pipefail

src="${1:?path to the 'iPhone 6.9″ for App Store' directory}"
out="$(cd "$(dirname "$0")/.." && pwd)/screenshots"

# Screen geometry measured from the frame template: the screen spans
# x=110..1180 in every image; "Fullscreen" images have the screen at
# y=229..2566, "Top" images start at y=628 and run off the bottom, and
# "Bottom" images start at the top edge and end at y=2117.
crop() { magick "$src/$1" -crop "$2" +repage "$out/$3.png"; echo "$3"; }

crop "en-US-1-Fullscreen Copy.png" 1070x2167+110+229 feed-text-dark
crop "en-US-2-Fullscreen.png"      1070x2337+110+229 feed-video-dark
crop "en-US-3-Top Copy.png"        1070x2167+110+628 feed-text-light
crop "en-US-5-Bottom.png"          1070x2117+110+0   profile-bluesky-light
crop "en-US-6-Top.png"             1070x2167+110+628 profile-own-light
crop "en-US-7-Top Dark Mode.png"   1070x2167+110+628 conversation-dark
crop "en-US-8-Top Dark Mode Copy.png" 1070x2167+110+628 compose-poll-light
