# pivix-antics

pixiv dump with github actions i guess:luminethonk:

# how to get pixiv parameter

 - log into pixiv, register an alt if you like, and enable R-18 and probably R-18G in its settings
 - visit a certain pixiv post, like this random fuckeqing pic: [https://www.pixiv.net/artworks/95228011](https://www.pixiv.net/artworks/95228011):thonkeqing:
 - smash F12, switch to the "Network" tab, and refresh
 - pick one network request, for example the very first one, and right click, copy, copy as cURL (POSIX), at least that's how it's done in firefox
 - and then delete the part like `curl 'https://www.pixiv.net/artworks/95228011'` and `-H 'Accept-Encoding: gzip, deflate, br'` and probably `--compressed`, and then there you go, copy them into the `curl parameters used by pixiv: ` part of github actions antics

# something about antics.v2.yml

this antics was intended to upload certain number of pics each time, too bad github didn't provide loop functions in yml to let me upload artifact every time i downloaded enough pics until there's no files to download:barbruh:

but at least it could stop certain steps if certain file doesn't exist on working directory, so i came up with another bash antics: 

 - make a template like yml file called antics.v2.original.yml to provide basic functions, the last three steps are basically identical to the three steps above them, but they renamed the rar archive with a ".part" to indicate that they're parts
 - and then use bash antics to copy these three steps as many times as i want, like 114.514 times in the final antics.v2.yml file, so if you see that file soooooooooooooooooooooooooooooooo long, pls don't be surpirsed:luminethonk:
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

basically you don't need to worry about this, unless 114.514 times was not enough for your pixiv antics, then have fun making it 114514 times, IIYO! KOIYO! use pixiv defloration hentai dumps to smash into these discord and twitter "anime child pornography" theorist faggots' chests! their chests!! (:wiebitte:

# what's new in antics.v3.yml? 

added a new criteria to move into the next download and reupload steps: file size

right now the original "Files Per Upload" became "Files Per Download", basically means files might be downloaded more than once before their size were too big to continue; in each download "Files Per Upload" number of lines would be feeded into aria2 and these lines would be removed from the original list, so whatever the loop is, it would work as usual:luminethonk:

as for "Filesize Per Upload", only when the size of then **exceeded** this number, the file download would be finally stopped, so the final archive size would always be bigger than the number you set, the less you set in "Files Per Upload" the more accurate it would be, but if you set that number too low, multithreading downloading of aria2 would not work properly:barbruh:

and one more thing: try to set "Filesize Per Upload" into 0, in this case it should be reduced into v2, files would be downloaded only once and then immediately repacked, but i would not try it:fischlthonk:

# both v2 and v3 tested on pivix defloration collections:wiebitte:

[https://github.com/AquaCriUGUU/pivix-antics/actions/runs/1652401659](https://github.com/AquaCriUGUU/pivix-antics/actions/runs/1652401659)

[https://github.com/AquaCriUGUU/pivix-antics/actions/runs/1653489286](https://github.com/AquaCriUGUU/pivix-antics/actions/runs/1653489286)

there you go, go piss off these vingin hentai haters:wiebitte:

wait, you gotta use more antics to download these shit in cli; like:

```bash
function dumpgithubartifacts() {
    for links in `eval "curl '$1' $parameters" | grep -Eo "/.*artifacts/[0-9]+" | sort | uniq`
    do
        for file in `eval "curl -I 'https://github.com$links' $parameters" | grep "[L|l]ocation:" | sed 's/[L/l]ocation: //g;s/[L/l]ocation://g'`
        do
            aria2c "$file"
            for file2 in `ls | grep zip`; do unzip "$file2"; done
            rm -f *.zip
        done
    done
}
```

and the parameters of github can use the same way you get with pixiv, you can just create an github alt and any github account can download them:luminethonk:
