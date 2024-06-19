cd $1
find *.tar.gz -maxdepth 1 -type f -exec sh -c 'echo "==> calculate hashsums for {}" && sha256sum {} > {}.sha2 && md5sum {} > {}.md5' \;
rm -rf dist
mkdir -p dist
mv *.tar.gz dist/
mv *.sha2 dist/
mv *.md5 dist/