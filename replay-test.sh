#!/bin/bash

SYSTEM=$1
shift
REGION=$1
shift

[ -d logs ] || mkdir -p logs
[ -d screenshots ] || mkdir -p screenshots

html=""
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
		html+='<tr><td>'"$gname"'</td><td>OK</td><td><img src="screenshots/'"$gname"'.png"></td><td><a href="logs/'"$gname"'.log">Logs</a></td></tr>'
		json+="{ \"name\": \"$gname\", \"status\": \"OK\", \"screenshot\": \"screenshots/$gname.png\", \"log\": \"logs/$gname.log\", \"system\": \"$SYSTEM\", \"region\": \"$REGION\" }"
		continue;
	fi
	echo Testing $gname
	params=""
	if [ $SYSTEM == "dreamcast" ] ; then
#		cp vmus/$gname.bin ~/.reicast/vmu_save_A1.bin
		rm ~/.reicast/vmu_save_A1.bin
		exe="reicast.elf"
		if [ $REGION == "eu" ]; then
			params="-config config:Dreamcast.Region=2 -config config:Dreamcast.Broadcast=1"
		elif [ $REGION == "jp" ]; then
			params="-config config:Dreamcast.Region=0 -config config:Dreamcast.Broadcast=0"
		else
			params="-config config:Dreamcast.Region=1 -config config:Dreamcast.Broadcast=0"
		fi
	elif [ $SYSTEM == "naomi" ] ; then
		exe="reicast_naomi.elf"
	else
		exe="reicast_awave.elf"
	fi
	/usr/bin/time --quiet -f "%U" -o elapsed_time ./$exe "$game" \
		-config record:replay_input=yes $params > "logs/$gname.log" 2>&1
	html+='<tr><td>'"$gname"'</td><td>'
	elapsed_time=`cat elapsed_time|tail -1`
	json+="{ \"name\": \"$gname\", \"duration\": \"$elapsed_time\", \"status\": "
	if [ $? == 0 -a -f screenshot.png ] ; then
		mv screenshot.png "screenshots/$gname.png"
		echo 'Success'
		html+='OK</td><td><img src="screenshots/'"$gname"'.png">'
		json+="\"OK\",  \"screenshot\": \"screenshots/$gname.png\""
	else
		echo '*** Failure ***'
		html+='FAIL</td><td><img src="fail.jpg">'
		json+="\"FAIL\",  \"screenshot\": \"fail.jpg\""
	fi
	html+='</td><td><a href="logs/'"$gname"'.log">Logs</a></td></tr>'
	json+=", \"log\": \"logs/$gname.log\", \"system\": \"$SYSTEM\", \"region\": \"$REGION\" }"
done

echo '<html><body><table><tr><th>Game</th><th>Status</th><th>Screenshot</th><tr>' > result-$REGION.html
echo "$html" >> result-$REGION.html
echo '</table></body></html>' >> result-$REGION.html 

echo "[" > result-$REGION.json
echo "$json" >> result-$REGION.json
echo "]" >> result-$REGION.json
