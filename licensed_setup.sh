#!/usr/bin/env nix-shell
#!nix-shell -i bash -p wget -p p7zip

if [ -f ./.secret.env ]; then
	source ./.secret.env
fi

mkdir -p gfx/licensed/modern
cd gfx/licensed
# This file contains the "Modern Interiors" and "Modern Exteriors" asset packs by limezu.
# It is encrypted, and the key is not public. You can download it and list its contents to
# get an idea of how to recreate it, if you have a license to use the assets yourself.
# It's also trivial to extract the assets we used in the game from the released artifacts,
# but the license requires us to put at least some effort in to prevent theft.
wget -Otmp.zip https://u.wolo.dev/~willow/licensed-assets/modern_int_ext.zip
7z x tmp.zip -omodern "-p$MODERN_PASSWORD"
rm tmp.zip

touch gfx/licensed/cookie
