for m in `ls | grep -v sh | grep -v md`
do
    ../../../crfsuite/crfsuite-0.12/bin/crfsuite learn -m ../30_models/$m.mdl $m/* > ../30_models/$m.out &
done
