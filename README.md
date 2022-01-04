# pivix-antics
pixiv dump with github actions i guess:luminethonk:

# something about antics.v2.yml

this antics was intended to upload certain number of pics each time, too bad github didn't provide loop functions in yml to let me upload artifact every time i downloaded enough pics until there's no files to download:barbruh:

but at least it could stop certain steps if certain file don't exist on working directory, so i came up with another bash antics: 

 - make a template like yml file called antics.v2.original.yml to provide basic functions, the last steps are basically identical to the three steps above them, but they renamed the rar archive with a ".part" to indicate that they're parts 
 - and then use bash antics to copy these three steps as many times as i want, like 114.514 times in the final antics.v2.yml file
 - but don't worry, when there's indeed no more files to download, the remaining steps would be skipped anyway

well, the bash antics i used was like: 

```bash
function generateyml() {
    [ "$1" ] && iteration="$1" || iteration=20
    originalfile="~/pivix-antics/.github/workflows/antics.v2.original.yml"
    resultfile="~/pivix-antics/.github/workflows/antics.v2.yml"
    linenum=`cat "$originalfile" | grep -n "Start Dumping" | tail -1 | grep -Eo "[0-9]+"`
    cat "$originalfile" | head -"$((linenum-1))" > "$resultfile"
    for iter in `seq 2 $iteration`
    do
        cat "$originalfile" | tail +"$((linenum))" | sed "s/partplaceholder/part$iter/g;s/Partplaceholder/Part $iter/g" >> "$resultfile"
    done
}
```

basically you don't need to worry about this, unless 114.514 times was not enough for your pixiv dumpin', then have fun making it 114514 times, IIYO! KOIYO! use pixiv defloration hentai dumps to smash into these discord and twitter "anime child pronography" theorist faggots' chests! their chests!! (:wiebitte:
