#!/bin/sh
# Cria g3d-cube-tools.love (um zip com o main.lua na raiz) para abrir no LÖVE do celular.
# Creates g3d-cube-tools.love (a zip with main.lua at its root) to open with LÖVE on a phone.
cd "$(dirname "$0")/.." || exit 1
rm -f g3d-cube-tools.love
zip -9 -r g3d-cube-tools.love main.lua conf.lua g3d g3d-iluminacao g3dui som3d.lua demos \
    LICENSE g3d-LICENSE THIRD_PARTY_NOTICES.md -x "*.DS_Store"
echo "Pronto / Done: g3d-cube-tools.love"
