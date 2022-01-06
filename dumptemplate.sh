[ -d "wiebitte" ] || mkdir wiebitte
while ( [ `du -s "wiebitte" | grep -Eo "[0-9]*\s" | grep -Eo "[0-9]*"` -lt $((${{{{ github.event.inputs.quota }}}}*1024)) ] && [ -s "list" ] )
do 
    echo `du -s "wiebitte" | grep -Eo "[0-9]*\s" | grep -Eo "[0-9]*"`
    head -${{{{ github.event.inputs.filesperdownload }}}} list > wiebitte/list
    tail +$((${{{{ github.event.inputs.filesperdownload }}}}+1)) list > list2
    rm -f list
    [ -s "list2" ] && mv list2 list
    cd wiebitte
    ../aria2c -k 1M -x 128 -s 128 -j 64 -R -c --auto-file-renaming=false --header "Referer: https://www.pixiv.net/artworks/1145141919810" -i list
    rm list -f
    cd ..
done

if [ "${{{{ github.event.inputs.listfilename }}}}" ]
then
    echo "${{{{ github.event.inputs.listfilename }}}}"
else
    if [ "${{{{ github.event.inputs.mode }}}}" = "artist" ]
    then
        filename="${{{{ github.event.inputs.mode }}}}.${{{{ github.event.inputs.artist }}}}"
    elif [ "${{{{ github.event.inputs.mode }}}}" = "tags" ]
    then
        filename="${{{{ github.event.inputs.mode }}}}.${{{{ github.event.inputs.tags }}}}"
    elif [ "${{{{ github.event.inputs.mode }}}}" = "combined" ]
    then
        filename="${{{{ github.event.inputs.mode }}}}.${{{{ github.event.inputs.artist }}}}.${{{{ github.event.inputs.tags }}}}"
    elif [ "${{{{ github.event.inputs.mode }}}}" = "list" ]
    then
        time=`date +%y.%m.%d`
        filename="${{{{ github.event.inputs.mode }}}}.$time"
    else
        filename="barbruh"
    fi
fi

mv "wiebitte" "$filename"
rar/rar a -df -ep1 -htb -m0 -ma5 -rr5 -ts -tsp -ol "$filename.partplaceholder.rar" "$filename"
return 0
