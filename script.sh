#!/bin/bash
for n in 1 2 3 4
do
    rm -rf Testcase${n}Diff
    for f1 in Testcase$n/*.1.txt
    do
        f2="${f1%.1.txt}.2.txt"
        name=$(basename "$f1" .1.txt)
        if ! diff -u "$f1" "$f2" > /dev/null
        then
            mkdir -p Testcase${n}Diff
            diff -u "$f1" "$f2" > Testcase${n}Diff/${name}Diff.txt
        fi
    done
done
