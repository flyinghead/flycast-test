#!/bin/bash

[ -d scripts ] || mkdir -p scripts

for game in ~/RetroPie/roms/systemsp/*.zip
do
	gname=`basename "$game" .zip`
	if [ -f "scripts/$gname.input" ] ; then
		echo Skipping $gname.zip
		continue
	fi
	if [ -f "options/$gname" ]; then options=`cat "options/$gname"`; else options=""; fi
	./flycast.elf "$game" -config record:record_input=yes $options
done

