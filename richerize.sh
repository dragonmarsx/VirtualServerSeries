#!/bin/bash
echo "FOLDER TO ITERATE"
echo "Each media file(s) will be moved inside its new folder."
for f in "$1"/*
do
    [ -d "$f" ] && continue
    base=${f%.*}
    echo $base
done
echo "Press Enter key to continue OR ^C to abort"
read
# if Enter key was pressed then:
for f in "$1"/*
do
    [ -d "$f" ] && continue
    base=${f%.*}
    echo $base
    mkdir -p "$base"
    cp -a "$f" "$base/"
done
