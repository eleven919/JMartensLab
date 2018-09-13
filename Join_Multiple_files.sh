#!/bin/sh

# multijoin - join multiple files

# sh Join_Multiple_files.sh *.txt > newfile

join_rec() {
    if [ $# -eq 1 ]; then
        join - "$1"
    else
        f=$1; shift
        join - "$f" | join_rec "$@"
    fi
}

if [ $# -le 2 ]; then
    join "$@"
else
    f1=$1; f2=$2; shift 2
    join "$f1" "$f2" | join_rec "$@"
fi
