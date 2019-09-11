#!/bin/bash

[ -d scripts ] || mkdir -p scripts
[ -d vmus ] || mkdir -p vmus

for game in ~/RetroPie/roms/dreamcast/Dreamcast/Games/NTSC-US/*.chd
do
	gname=`basename "$game" .chd`
	if [ -f "scripts/$gname.input" ] ; then
		echo Skipping $gname.chd
		continue
	fi
        if [ -f "options/$gname" ]; then options=`cat "options/$gname"`; else options=""; fi
#	cp vmus/$gname.bin ~/.reicast/vmu_save_A1.bin
	rm ~/.reicast/vmu_save_A1.bin
	./reicast.elf "$game" -config record:record_input=yes -config config:Dreamcast.Region=1 \
		-config config:Dreamcast.Broadcast=0 $options
	mv ~/.reicast/vmu_save_A1.bin "vmus/$gname.bin"
done

