for f in `find . -type f | grep -v .sh`
do
    ruby ../../scripts/extract-tagged.rb < $f > ../40_extractions/$f;
done
