[ -d "wiebitte" ] || mkdir wiebitte
[ -f "../parameters.txt" ] && parameters=`cat ../parameters.txt` || parameters="-H 'Referer: https://www.pixiv.net/artworks/1145141919810' "
parameters4aria2="${parameters//--compressed/ }"
parameters4aria2="${parameters4aria2//-H/--header}"
while ( [ `du -s "wiebitte" | grep -Eo "[0-9]*\s" | grep -Eo "[0-9]*"` -lt $((____github.event.inputs.quota----*1024)) ] && [ -s "list" ] )
do 
    echo `du -s "wiebitte" | grep -Eo "[0-9]*\s" | grep -Eo "[0-9]*"`
    head -____github.event.inputs.filesperdownload---- list > wiebitte/list
    tail +$((____github.event.inputs.filesperdownload----+1)) list > list2
    rm -f list
    [ -s "list2" ] && mv list2 list
    cd wiebitte
    while [ -s list ]
    do
        eval "../aria2c -k 1M -x 1 -s 1 -j 64 -R -c --auto-file-renaming=false $parameters4aria2 -i list --save-session list"
    done
    rm list -f
    cd ..
done

if [ "____github.event.inputs.archivefilename----" ]
then
    filename="____github.event.inputs.archivefilename----"
else
    if [ "____github.event.inputs.mode----" = "artist" ]
    then
        filename="____github.event.inputs.mode----.____github.event.inputs.artist----"
    elif [ "____github.event.inputs.mode----" = "tags" ]
    then
        filename="____github.event.inputs.mode----.____github.event.inputs.tags----"
    elif [ "____github.event.inputs.mode----" = "combined" ]
    then
        filename="____github.event.inputs.mode----.____github.event.inputs.artist----.____github.event.inputs.tags----"
    elif [ "____github.event.inputs.mode----" = "list" ]
    then
        time=`date +%y.%m.%d`
        filename="____github.event.inputs.mode----.$time"
    else
        filename="barbruh"
    fi
fi

mv "wiebitte" "$filename"
rar/rar a -df -ep1 -htb -m0 -ma5 -rr5 -ts -tsp -ol "$filename.partplaceholder.rar" "$filename"
exit 0
