#!/bin/bash

[ -d scripts ] || mkdir -p scripts
[ -d vmus ] || mkdir -p vmus

for game in ~/RetroPie/roms/dreamcast/Dreamcast/Games/NTSC-JP/*.chd
do
	gname=`basename "$game" .chd`
	if [ -f "scripts/$gname.input" ] ; then
		echo Skipping $gname.chd
		continue
	fi
#	cp vmus/$gname.bin ~/.reicast/vmu_save_A1.bin
	rm ~/.reicast/vmu_save_A1.bin
	./reicast.elf "$game" -config record:record_input=yes -config config:Dreamcast.Region=0 \
		-config config:Dreamcast.Broadcast=0
	mv ~/.reicast/vmu_save_A1.bin "vmus/$gname.bin"
done
