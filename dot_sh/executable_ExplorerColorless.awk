#!/usr/bin/awk -f

BEGIN {
    ses[0] = " "
    ses[1] = "│"
    ses[2] = "╰"
    ses[3] = "╰"
}

{
    fs=sprintf("%*s",$2,"")
    gsub(" ",">",fs)
    is=sprintf("%*s",$3,"")
    se=ses[$4]
    print fs is se " " $1 " " $5
}
