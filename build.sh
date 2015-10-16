#!/usr/bin/env sh

set -x

P="Pepa"
LD="love-0.9.2-win32"

cd src
zip -9 -r - . > "../${P}.love"
cd ..

tmp=`mktemp -d 2>/dev/null || mktemp -d -t 'mytmpdir'`
mkdir "$tmp/$P"
cat "$LD/love.exe" "${P}.love" > "$tmp/${P}/${P}.exe"
cp "$LD"/*dll "$LD"/license* "$tmp/$P"
cd "$tmp"
zip -9 -r - "$P" > "${P}.zip"
cd -
cp "$tmp/${P}.zip" .
rm -r "$tmp"
