for d in `ls | grep -v R | grep -v sh`; do
    features=$(ruby ../../scripts/smart-extract.rb $d/* | tail -n 1)
    for f in `find $d -type f`; do
        ruby ../../scripts/extract.rb $features < $f > ../21_labled_inst/${f%.html} &
    done
done
