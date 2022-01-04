function pixiv { # $1 = id
    for links in `eval "curl 'https://www.pixiv.net/ajax/illust/$1/pages?lang=en' $parameters" 2>/dev/null | sed 's/\\\\\\//\\//g;s/},{/},\n{/g;s/}, {/},\n{/g;s/","/",\n"/g' | grep 'original' | sed 's/"/\n/g' | grep "http"`
    do
        if [ `echo "$links" | grep "ugoira"` ]
        then
            for zip in `eval "curl 'https://www.pixiv.net/ajax/illust/$1/ugoira_meta?lang=en' $parameters" 2>/dev/null | sed 's/\\\\\\//\\//g;s/},{/},\n{/g;s/}, {/},\n{/g;s/","/",\n"/g'  | grep 'originalSrc' | sed 's/"/\n/g' | grep "http"`
            do
                [ "$loglevel" = "verbose" ] && echo -e "    \e[32m$zip\e[36m added into aria2 list\e[0m"
                echo "$zip" >> list
            done
        else
            [ "$loglevel" = "verbose" ] && echo -e "    \e[32m$links\e[36m added into aria2 list\e[0m"
            echo "$links" >> list
        fi
    done
}

function pixiv_by_artist { # $1 = artist id
    total=`eval "curl 'https://www.pixiv.net/ajax/user/$1/profile/all?lang=en' $parameters" 2>/dev/null | grep -Po '"illusts":{.*?}' | sed 's/"/\n/g' | grep -Ec "[0-9]+"`
    echo -e "\e[36mFound \e[32m$total\e[36m illustrations\e[0m"
    current=0
    for illust in `eval "curl 'https://www.pixiv.net/ajax/user/$1/profile/all?lang=en' $parameters" 2>/dev/null | grep -Po '"illusts":{.*?}' | sed 's/"/\n/g' | grep -E "[0-9]+"`
    do
        let current++
        [ "$loglevel" = "silent" ] || echo -e "  \e[36mProgress \e[32m$current\e[36m/$total, Processin' illustration id \e[32m$illust\e[36m: \e[0m"
        pixiv "$illust"
    done
    ../aria2c -k 1M -x 128 -s 128 -j 64 -R -c --auto-file-renaming=false --header "Referer: https://www.pixiv.net/artworks/1145141919810" -i list
    rm list -f
}

function pixiv_by_artist_and_tags { # $1 = artist id, $2 = tags
    tags="${2// /%20}"
    total=`eval "curl 'https://www.pixiv.net/ajax/user/$1/illusts/tag?tag=$tags&offset=0&limit=48&lang=en' 2>/dev/null $parameters" | grep -Eo '"total":[0-9]+' | grep -Eo "[0-9]+"`
    echo -e "\e[36mFound \e[32m$total\e[36m illustrations\e[0m"
    current=0
    for offset in `seq 0 48 $total`
    do
        for illust in `eval "curl 'https://www.pixiv.net/ajax/user/$1/illusts/tag?tag=$tags&offset=$offset&limit=48&lang=en' 2>/dev/null $parameters" | sed 's/},{/},\n{/g' | grep -Eo '"id":"[0-9]+","title"' | grep -Eo "[0-9]+"`
        do
            let current++
            [ "$loglevel" = "silent" ] || echo -e "  \e[36mProgress \e[32m$current\e[36m/$total, Processin' illustration id \e[32m$illust\e[36m: \e[0m"
            pixiv "$illust"
        done
    done
    ../aria2c -k 1M -x 128 -s 128 -j 64 -R -c --auto-file-renaming=false --header "Referer: https://www.pixiv.net/artworks/1145141919810" -i list
    rm list -f
}

function pixiv_by_tags { # $1 = tags
    tags="${1// /%20}"
    total=`eval "curl 'https://www.pixiv.net/ajax/search/artworks/$tags?word=$tags&order=date_d&mode=all&p=1&s_mode=s_tag&type=all&lang=en' 2>/dev/null $parameters" | grep -Eo '"total":[0-9]+' | grep -Eo "[0-9]+"`
    echo -e "\e[36mFound \e[32m$total\e[36m illustrations\e[0m"
    for page in `seq 1 $((total/60+1))`
    do
        for illust in `eval "curl 'https://www.pixiv.net/ajax/search/artworks/$tags?word=$tags&order=date_d&mode=all&p=$page&s_mode=s_tag&type=all&lang=en' 2>/dev/null $parameters" | sed 's/},{/},\n{/g' | grep -Eo '"id":"[0-9]+","title"' | grep -Eo "[0-9]+"`
        do
            let current++
            [ "$loglevel" = "silent" ] || echo -e "  \e[36mProgress \e[32m$current\e[36m/$total, Processin' illustration id \e[32m$illust\e[36m: \e[0m"
            pixiv "$illust"
        done
    done
    ../aria2c -k 1M -x 128 -s 128 -j 64 -R -c --auto-file-renaming=false --header "Referer: https://www.pixiv.net/artworks/1145141919810" -i list
    rm list -f
}

parameters=`cat ../parameters.txt`
loglevel="$1"
if [ "$2" = "artist" ]
then
    pixiv_by_artist "$3"
elif [ "$2" = "tags" ]
then
    pixiv_by_tags "$4"
elif [ "$2" = "combined" ]
then
    pixiv_by_artist_and_tags "$3" "$4"
else
    echo "AquaCriUGUU"
fi
