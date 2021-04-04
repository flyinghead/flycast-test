#/bin/bash
set -ex

[ -d flycast ] || git clone https://github.com/flyinghead/flycast
cd flycast/shell/linux
git fetch
git checkout $1
git pull
make TEST_AUTOMATION=1 clean
make TEST_AUTOMATION=1 -j8
mv -f flycast.elf ../../..
cd ../../..
