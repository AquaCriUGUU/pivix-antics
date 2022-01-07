# pivix-antics

pixiv dump with github actions i guess:luminethonk:

# how to get pixiv parameter

 - log into pixiv, register an alt if you like, and enable R-18 and probably R-18G in its settings
 - visit a certain pixiv post, like this random fuckeqing pic: [https://www.pixiv.net/artworks/95228011](https://www.pixiv.net/artworks/95228011):thonkeqing:
 - smash F12, switch to the "Network" tab, and refresh
 - pick one network request, for example the very first one, and right click, copy, copy as cURL (POSIX), at least that's how it's done in firefox
 - (obsolete) ~~and then delete the part like `curl 'https://www.pixiv.net/artworks/95228011'` and `-H 'Accept-Encoding: gzip, deflate, br'` and probably `--compressed`, and then there you go, copy them into the `curl parameters used by pixiv: ` part of github actions antics~~
 - just copy them into the `curl parameters used by pixiv: ` part of github actions antics, and it should automatically delete the unnecessary part itself:fischlthonk:

# something about antics.v2.yml and probably antics.v3.yml too

this antics was intended to upload artifact every time i downloaded enough pics until there's no files to download, since certain pixiv tags would totally use up its little space to upload them in one go, too bad github didn't provide loop functions in yml:barbruh:

but at least it could stop certain steps if certain file doesn't exist on working directory, so i came up with another bash antics: 

 - make a template like yml file called antics.v2.original.yml to provide basic functions, the last three steps are basically identical to the three steps above them, but they renamed the rar archive with a ".part" to indicate that they're parts
 - and then use bash antics to copy these three steps as many times as i want, like 114.514 times in the final antics.v2.yml file, so if you see that file soooooooooooooooooooooooooooooooo long, pls don't be surpirsed:luminethonk:
 - but don't worry, when there's indeed no more files to download, the remaining steps would be skipped anyway

well, the bash antics i used was like: 

```bash
function generateyml() {
    [ "$1" ] && iteration="$1" || iteration=20
    originalfile=".github/workflows/antics.v3.original.yml"
    resultfile=".github/workflows/antics.v3.yml"
    linenum=`cat "$originalfile" | grep -n "Start Dumping" | tail -1 | grep -Eo "[0-9]+"`
    cat "$originalfile" | head -"$((linenum-1))" | sed "s/pixiv antics v3 (original/pixiv antics v3/g" > "$resultfile"
    for iter in `seq 2 $iteration`
    do
        cat "$originalfile" | tail +"$((linenum))" | sed "s/partPlaceholder/part$iter/g;s/Partplaceholder/Part $iter/g" >> "$resultfile"
        echo >> "$resultfile"
        echo >> "$resultfile"
    done
}
```

basically you don't need to worry about this, unless 114.514 times was not enough for your pixiv antics, then have fun making it 114514 times, IIYO! KOIYO! use pixiv defloration hentai dumps to smash into these discord and twitter "anime child pornography" theorist faggots' chests! their chests!! (:wiebitte:

# wiebitte.yml

of course, i made another yml to automatically generate antics.v3.yml from antics.v3.original.yml, as long as antics.v3.original.yml was pushed, it would ba automatically triggered, and antics.v3.yml would be generated within a minute

but, if you want this antics to work on your fork of this repository, probably you need to do some extra steps: 
 - go apply for a new pat (personal access token) in [https://github.com/settings/tokens](https://github.com/settings/tokens), just allow workflow perm
 - add the secret key you got from the last step (it would only show once! ) in a new repository secret in [https://github.com/your-username/pivix-antics/settings/secrets/actions](https://github.com/your-username/pivix-antics/settings/secrets/actions), you can just name it `AquaCriUGUU` or `AQUACRIUGUU` so you don't need to change the script:luminethonk:
 - and probably you should just enable actions first in [https://github.com/your-username/pivix-antics/settings/actions](https://github.com/your-username/pivix-antics/settings/actions)

# what's new in antics.v3.yml? 

added a new criteria to move into the next download and reupload steps: file size

right now the original "Files Per Upload" became "Files Per Download", basically means files might be downloaded more than once before their size were too big to continue; in each download "Files Per Upload" number of lines would be feeded into aria2 and these lines would be removed from the original list, so whatever the loop is, it would work as usual:luminethonk:

as for "Filesize Per Upload", only when the size of them **exceeded** this number, the file download would be finally stopped, so the final archive size would always be bigger than the number you set, the less you set in "Files Per Upload" the more accurate it would be, but if you set that number too low, multithreading downloading of aria2 would not work properly, so it needs to be at least 64 and better be over 256:barbruh:

and one more thing: try setting "Filesize Per Upload" into 0, in this case it should be reduced into v2, files would be downloaded only once and then immediately repacked, but i would not try it:fischlthonk:

# both v2 and v3 tested on pivix defloration collections:wiebitte:

v2[https://github.com/AquaCriUGUU/pivix-antics/actions/runs/1652401659](https://github.com/AquaCriUGUU/pivix-antics/actions/runs/1652401659)

v3[https://github.com/AquaCriUGUU/pivix-antics/actions/runs/1653489286](https://github.com/AquaCriUGUU/pivix-antics/actions/runs/1653489286)

there you go, go piss off these vingin hentai haters:wiebitte:

wait, you gotta use more antics to download these shit in cli; like:

```bash
function dumpgithubartifacts() {
    parameters=`echo "$parameters"| sed "s/-H 'Accept-Encoding: gzip, deflate, br' //g;s/--compressed//g;s/curl '[^']*' //g"` # added some preprocessing
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

and the parameters of github can use the same way you get with pixiv, you can just create a github alt and any github account can download them:luminethonk:

> and a frinedly reminder that these files could only be downloaded in single thread and the speed is slow af (less than 100Mbps), so pls don't use vultr's hourly billed vps to transfer them elsewhere:AquaCriUGUU:

# about genshin impact's character censorship thingy (rip jean chan's halfboobs

well, it's some radical feminists' magma opus (hakushin

they would like to see men suffer, so they reported our kawaii jean chan, amber, mona and rosaria, and you know what, it's not over yet! they are planning to report raiden, shenhe, ganyu and even hutao chan! wait, why tf hutao chan? what would they report her for, her boobs are too smol? 

![](https://cdn.discordapp.com/attachments/655564135198621707/928238070879371285/1641379572673_d166b909j00r583jo001jc000ez00jvm.jpg)

i mean seriously the fucking wiebitte fuck, these feminazis are just ugly fat bitches that no one would like to bang even if they're virgins, besides, i guess they definitely didn't have blue eyes

and i suppose, the radical feminists are actually GLOBAL cancer now, it's not only a problem of the western world anymore:bruhfei:

to fight this abomination and protect our blue eyes anime cuties, probably international collaboration would be required; i wish these fucking bitches would soon be doxxed by the few doxxing spezialists in the vast millions of genshin impact players, it must be at least ten of them, right? and then, let's fuck their laifu up! :Vengeance:

you want us to suffer? I WANT YOU TO SUFFER TOO! let me guess, after they're fucking doxxed, we can easily discover that these sukas must get their graduation certs and degrees by fucking their professors with their of course no longer virgin pussies, since one of them indeed realized that the pussy on their body could be used to exchange with anything they want, money, luxuries, and of course, the graduation certs they didn't deserve. whatever the fuck they wrote in their graduation thesis, are definitely useless bullshit that was plagiarized from someone else; they report jean chan? we report their graduation thesis! and then we watch their graduation certs and degrees REVOKED, we watch their boyfriend(s) break up with them, watch their husbands (if any) divorced, and then we watch their life BURN IN HELL! IIYO! KOIYO! smash our diccs into their pussies! their pussies!! (oouso
