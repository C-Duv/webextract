for r in `ls | grep -v R | grep -v sh`
do
    for f in `ls $r`
    do
        echo "/home/gdifolco/ps11/crfsuite-0.12/bin/crfsuite tag -m /home/gdifolco/ps11/dataset/30_models/$r.mdl -t /home/gdifolco/ps11/dataset/11_raw_inst/$r/$f > /home/gdifolco/ps11/dataset/41_tags/$r/$f"
    done
done
