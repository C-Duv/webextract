for m in `ls *.out`
do
    echo -n "$m | "; ruby ../../scripts/extract-learn-bench.rb < $m
done >> README.md
