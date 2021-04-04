#!/bin/bash

[ -d scripts ] || mkdir -p scripts

while read -r game
do
	gname=`basename "$game" .zip`
	if [ ! -f "RetroPie/roms/naomi/$game" ] ; then
		echo Skipping $game  \(not found\)
		continue
	fi
	if [ -f "scripts/$gname.input" ] ; then
		echo Skipping $game \(existing script\)
		continue
	fi
	if [ -f "options/$gname" ]; then options=`cat "options/$gname"`; else options=""; fi
	./flycast.elf "RetroPie/roms/naomi/$game" -config record:record_input=yes $options
done < atomiswave-games.txt

