function rosefile_v3_for_github_actions() {
    pw=""
    url="$1"
    [ "$2" ] && order="$2" || order=1
    [ "$3" ] && pw=".$3"
    filename=${url##*/}
    filename=${filename%.html}
    parameter="-b barbruh.txt -H 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:95.0) Gecko/20100101 Firefox/95.0' -H 'Accept: text/plain, */*; q=0.01' -H 'Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh-HK;q=0.5,en-US;q=0.3,en;q=0.2' -H 'Referer: $1' -H 'Content-Type: application/x-www-form-urlencoded; charset=UTF-8' -H 'X-Requested-With: XMLHttpRequest' -H 'Origin: https://rosefile.net' -H 'Connection: keep-alive' -H 'Sec-Fetch-Dest: empty' -H 'Sec-Fetch-Mode: cors' -H 'Sec-Fetch-Site: same-origin' -H 'Pragma: no-cache' -H 'Cache-Control: no-cache' -H 'TE: trailers' "
    fileid=`eval "curl '$url' $parameter" | grep "add_ref(" | grep -Eo "[0-9]+"`
    if [ "$fileid" ]
    then
        for fileurl in `eval "curl -X POST 'https://rosefile.net/ajax.php' $parameter --data 'action=load_down_addr1&file_id=$fileid'" | sed 's/"/\n/g' | grep "http" | sed -n "$order"p`
        do
            echo "$fileurl"
        done
        if [ `echo "$fileurl" | grep "rosefile.net"` ]
        then
            parameter2aria2=`echo "$parameter" | sed 's/--compressed //g;s/-H/--header/g;s/-b barbruh.txt//g'`
        else
            parameter2aria2="--header 'User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:95.0) Gecko/20100101 Firefox/95.0' --header 'Accept: text/html,application/xhtml+xml,application/xml;q=0.9,image/avif,image/webp,*/*;q=0.8' --header 'Accept-Language: zh-CN,zh;q=0.8,zh-TW;q=0.7,zh--headerK;q=0.5,en-US;q=0.3,en;q=0.2' --header 'Referer: $url' --header 'Connection: keep-alive' --header 'Upgrade-Insecure-Requests: 1' --header 'Sec-Fetch-Dest: document' --header 'Sec-Fetch-Mode: navigate' --header 'Sec-Fetch-Site: cross-site' --header 'Sec-Fetch-User: ?1'"
        fi
        targetfilepath=`eval "./aria2c -k 1M -x 64 -s 64 -j 64 -R -c --auto-file-renaming=false $parameter2aria2 --out '${filename%.*}$pw.${filename##*.}' '$fileurl' " | tee /dev/stderr | grep "|OK" | cut -d\| -f4`
        if [ "$targetfilepath" ]
        then
            bash "${____github.event.inputs.mysteriousbashscripturl----##*/}" "$targetfilepath" > /dev/null 2> /dev/null
            rm -f "$targetfilepath.114514"
        fi
    fi
}

rosefile_v3_for_github_actions "$1" 2
