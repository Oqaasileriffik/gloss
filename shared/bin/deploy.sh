#!/bin/bash
set -e
DIR=$(cd $(dirname $0) ; pwd)

export "PATH=/opt/local/libexec/gnubin:$PATH"
export DESTDIR=/tmp/deploy-gloss
export "HOMEDIR=$DESTDIR/gloss"
rm -rf "$DESTDIR"

mkdir -pv "$HOMEDIR/langtech/"

cp -avf "$DIR/../../../gloss" "$HOMEDIR/langtech/"
pushd "$HOMEDIR/langtech/gloss"
	git clean -f -d -x
	rm -rf .git
	find . -type f -name '*.cg3' -print0 | xargs -0r -IX vislcg3 --grammar-only -g X --grammar-bin Xb
	find . -type f -name '*.yaml' -print0 | xargs -0r -IX bash -c "echo X; cat X | perl -wpne 's/cg3-autobin.pl/vislcg3/g; s/[.]cg3/.cg3b/g;' > X.new; mv X.new X"
popd

cp -avf "$DIR/../etc/Dockerfile" "$DESTDIR/"

mkdir -pv "$HOMEDIR/langtech/katersat/"
cd ~/langtech/katersat
git ls-files --exclude-standard -z | xargs -0r -IX cp -avf X "$HOMEDIR/langtech/katersat/X"
cp -avf katersat.sqlite "$HOMEDIR/langtech/katersat/"

cd ~/langtech/kal
make install "DESTDIR=$DESTDIR"

for CG in dependency disambiguator functions kal-pre1 kal-pre2 kal-augment
do
	ln -sfv "$CG.bin" "$DESTDIR/usr/local/share/giella/kal/$CG.cg3b"
done
