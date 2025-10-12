#!/usr/bin/awk -f

BEGIN {
    ses[0] = " "
    ses[1] = "│"
    ses[2] = "╰"
    ses[3] = "╰"
}

{
    if ($2 == 0 && $3 == 0) {
        printf("%-*.*s\n", w, w, " " $1 " " $5)
        next
    }
    fs=sprintf("%*s",$2,"")
    gsub(" ",">",fs)
    is=sprintf("%*s",1+($3-1)*2,"")
    se=ses[$4]
    printf("%-*.*s\n", w, w, fs is se " " $1 " " $5)
}
