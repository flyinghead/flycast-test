#!/bin/bash

SYSTEM=$1
shift
REGION=$1
shift

[ -d logs ] || mkdir -p logs
[ -d screenshots ] || mkdir -p screenshots

json=""

while (( "$#" ))
do
	game=$1
	shift
	gname=`basename "$game" .chd`
	gname=`basename "$gname" .zip`
	gname=`basename "$gname" .cdi`
        if [[ "$gname" =~ ^.*\(Disc\ [2-4]\ of.*$ ]] ; then
                echo Skipping multiple discs $gname
                continue;
        fi
	if [ ! -f "scripts/$gname.input" ] ; then
		echo Skipping $gname \(no input script\)
		continue
	fi
	if [ "$json" != "" ]; then
		json+=","
	fi
	if [ -f "screenshots/$gname.png" ] ; then
		echo Skipping $gname \(existing screenshot\)
		json+="{ \"name\": \"$gname\", \"status\": \"OK\", \"screenshot\": \"screenshots/$gname.png\", \"log\": \"logs/$gname.log\", \"system\": \"$SYSTEM\", \"region\": \"$REGION\" }"
		continue;
	fi
	echo Testing $gname
	params=""
	exe="reicast.elf"
	if [ -f "options/$gname" ]; then options=`cat "options/$gname"`; else options=""; fi
	if [ $SYSTEM == "dreamcast" ] ; then
#		cp vmus/$gname.bin ~/.reicast/vmu_save_A1.bin
		rm ~/.reicast/vmu_save_A1.bin
		if [ $REGION == "eu" ]; then
			params="-config config:Dreamcast.Region=2 -config config:Dreamcast.Broadcast=1"
		elif [ $REGION == "jp" ]; then
			params="-config config:Dreamcast.Region=0 -config config:Dreamcast.Broadcast=0"
		else
			params="-config config:Dreamcast.Region=1 -config config:Dreamcast.Broadcast=0"
		fi
	fi
	/usr/bin/time --quiet -f "%U" -o elapsed_time ./$exe "$game" \
		-config record:replay_input=yes $params $options > "logs/$gname.log" 2>&1
	elapsed_time=`cat elapsed_time|tail -1`
	json+="{ \"name\": \"$gname\", \"duration\": \"$elapsed_time\", \"status\": "
	if [ $? == 0 -a -f screenshot.png ] ; then
		mv screenshot.png "screenshots/$gname.png"
		echo 'Success'
		json+="\"OK\",  \"screenshot\": \"screenshots/$gname.png\""
	else
		echo '*** Failure ***'
		json+="\"FAIL\",  \"screenshot\": \"fail.jpg\""
	fi
	json+=", \"log\": \"logs/$gname.log\", \"system\": \"$SYSTEM\", \"region\": \"$REGION\" }"
done

echo "[" > result-$REGION.json
echo "$json" >> result-$REGION.json
echo "]" >> result-$REGION.json
