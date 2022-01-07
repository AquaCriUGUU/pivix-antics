function rule34xxx() {
    cutie="$1"
    url="https://rule34.xxx/index.php?page=post&s=list&tags=$cutie"
    url=${url// /%20}
    finalfish=`curl "$url" | grep -Eo "pid=[0-9]*\" alt=\"last page\"" | sed 's/pid=//g' | sed 's/" alt="last page"//g'`
    echo 
    if [ ! $finalfish ]
    then
        finalfish=20
        echo -e "\e[36mFound \e[32mless than $finalfish\e[36m illustrations\e[0m"
    else
        echo -e "\e[36mFound \e[32m$finalfish\e[36m illustrations\e[0m"
    fi
    
    
    for fish in `seq 0 42 $finalfish`
    do
        [ "$loglevel" = "silent" ] || echo -e "  \e[36mProgress \e[32m$fish\e[36m/$finalfish: \e[0m"
        url="https://rule34.xxx/index.php?page=post&s=list&tags=$cutie&pid=$fish"
        url=${url// /%20}
        
        for hentailink in `curl "$url" | sed 's/>/\n/g' |  grep -Eo "view&id=[0-9]*" | grep -Eo "[0-9]*"` # find id's
        do
            hentai=`curl "https://rule34.xxx/index.php?page=post&s=view&id=$hentailink" | grep '<meta property="og:image"' | sed 's/"/\n/g' | grep "http"`
            [ "$loglevel" = "verbose" ] && echo -e "    \e[32m$hentai\e[36m added into aria2 list\e[0m"
            echo "$hentai" >> list
        done
    done
}

rule34xxx "$1"
