#!/usr/bin/awk -f

BEGIN {
    ses[0] = " "
    ses[1] = "│"
    ses[2] = "╰"
    ses[3] = "╰"
}

{
    if ($2 == 0 && $3 == 0) {
        print " " $1 " " $5
        next
    }
    fs=sprintf("%*s",$2,"")
    gsub(" ",">",fs)
    is=sprintf("%*s",$3*2,"")
    se=ses[$4]
    print fs is se " " $1 " " $5
}
