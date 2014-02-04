for m in `ls | grep -v sh | grep -v RE`
do
    for f in `find "$m" -type f`
    do
        ../../../crfsuite/crfsuite-0.12/bin/crfsuite tag -m ../30_models/$m.mdl -t $f > ../41_tags/$f &
    done
done
