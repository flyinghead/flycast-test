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
	rm ~/.local/share/flycast/vmu_save_A1.bin
	./flycast.elf "$game" -config record:record_input=yes -config config:Dreamcast.Region=1 \
		-config config:Dreamcast.Broadcast=0 $options
done

