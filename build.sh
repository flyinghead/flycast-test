#/bin/bash
set -ex

[ -d flycast ] || git clone https://github.com/flyinghead/flycast
cd flycast
git fetch
git checkout $1
git pull
git submodule update --init --recursive
mkdir -p build
cd build
cmake -DCMAKE_BUILD_TYPE=Release -DTEST_AUTOMATION=ON ..
make clean
make -j8
mv -f flycast ../../flycast.elf
cd ../..
