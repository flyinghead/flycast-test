#!/bin/bash

./build.sh master || (echo "Build failed" && exit 1)

# Disable Vsync on Mesa
vblank_mode=0
export vblank_mode

rm -rf screenshots
rm -rf logs
./replay-test.sh dreamcast us ~/RetroPie/roms/dreamcast/Dreamcast/Games/NTSC-US/*.chd
./replay-test.sh dreamcast eu ~/RetroPie/roms/dreamcast/Dreamcast/Games/PAL/*.chd
./replay-test.sh dreamcast jp ~/RetroPie/roms/dreamcast/Dreamcast/Games/NTSC-JP/*.chd
naomi_games=""
while read -r game
do
	naomi_games+=" RetroPie/roms/naomi/$game"
done < naomi-games.txt
./replay-test.sh naomi naomi $naomi_games
awave_games=""
while read -r game
do
	awave_games+=" RetroPie/roms/naomi/$game"
done < atomiswave-games.txt
./replay-test.sh awave awave $awave_games

githash=`cd flycast; git rev-parse --short=7 HEAD`
aws s3 cp --acl public-read result-us.json s3://flycast-tests/$githash/
aws s3 cp --acl public-read result-eu.json s3://flycast-tests/$githash/
aws s3 cp --acl public-read result-jp.json s3://flycast-tests/$githash/
aws s3 cp --acl public-read result-naomi.json s3://flycast-tests/$githash/
aws s3 cp --acl public-read result-awave.json s3://flycast-tests/$githash/
aws s3 cp --acl public-read --recursive logs/ s3://flycast-tests/$githash/logs/
aws s3 cp --acl public-read --recursive screenshots/ s3://flycast-tests/$githash/screenshots/
