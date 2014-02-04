for m in `ls | grep -v sh`
do
    for f in `find "$m" -type f`
    do
        echo -n "$f | "
        ruby ../../scripts/extract-tags-bench.rb < $f
    done
done >> ../40_extractions/README.md
