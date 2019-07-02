#/bin/bash
set -ex

[ -d flycast ] || git clone https://github.com/flyinghead/flycast
cd flycast/shell/linux
git checkout fh/wince-dynarec
git pull
make TEST_AUTOMATION=1 clean
make TEST_AUTOMATION=1 -j8
mv -f reicast.elf ../../..
make TEST_AUTOMATION=1 NAOMI=1 clean
make TEST_AUTOMATION=1 NAOMI=1 -j8
mv -f reicast_naomi.elf ../../..
make TEST_AUTOMATION=1 ATOMISWAVE=1 clean
make TEST_AUTOMATION=1 ATOMISWAVE=1 -j8
mv -f reicast_awave.elf ../../..
cd ../../..
