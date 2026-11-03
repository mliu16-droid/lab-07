#!/bin/bash
status=0
for n in 1 2 3 4
do
    ok=1
    anydiff=0
    for f1 in Testcase$n/*.1.txt
    do
        f2="${f1%.1.txt}.2.txt"
        name=$(basename "$f1" .1.txt)
        outfile="Testcase${n}Diff/${name}Diff.txt"

        if diff -u "$f1" "$f2" > /dev/null
        then
            if [ -e "$outfile" ]
            then
                echo "不该存在: $outfile" >&2
                ok=0
            fi
        else
            anydiff=1
            if [ ! -f "$outfile" ]
            then
                echo "Lackage: $outfile" >&2
                ok=0
            elif ! cmp -s <(diff -u "$f1" "$f2" | tail -n +3) <(tail -n +3 "$outfile")
            then
                echo "Content error: $outfile" >&2
                ok=0
            fi
        fi
    done
    if [ $anydiff -eq 1 ] && [ ! -d Testcase${n}Diff ]
    then
        echo "Lack of Files: Testcase${n}Diff" >&2
        ok=0
    fi
    if [ $anydiff -eq 0 ] && [ -e Testcase${n}Diff ]
    then
        echo "Some files should not exist: Testcase${n}Diff" >&2
        ok=0
    fi

    if [ $ok -eq 1 ]
    then
        echo "Testcase$n: PASS"
    else
        echo "Testcase$n: FAIL"
        status=1
    fi
done
exit $status
