for d in `ls | grep -v R | grep -v sh`; do
    features=$(ruby ../../scripts/smart-extract.rb $d/* | tail -n 1)
    for f in `ls ../10_raw_html/$d`; do
        nf=${f#};
        ruby ../../scripts/extract.rb $features < ../10_raw_html/$d/$f > ../11_raw_inst/$d/${nf%.html} &
    done
done
