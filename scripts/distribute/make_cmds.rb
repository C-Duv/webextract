mdls = Dir.entries('../../dataset/30_models').select { |n| n =~ /mdl$/ }

mdls.each do |mdl|
    targetDir = mdl.match(/^.*_(.+)\.mdl$/)[1]
    mdlRoot = mdl.match(/^(.*)_.*$/)[1]
    puts "mkdir ../../dataset/41_tags/" + targetDir + "/" + mdlRoot
    # targets = Dir.entries('../../dataset/11_raw_inst/' + targetDir).select { |n| n != '.' && n != '..'}
    # targets.each do |t|
    #     dest = targetDir + "/" + mdlRoot  + "/"  + t
    #     puts '/home/gdifolco/ps11/crfsuite-0.12/bin/crfsuite tag -m /home/gdifolco/ps11/dataset/30_models/' + mdl + " -t " + '/home/gdifolco/ps11/dataset/11_raw_inst/' + targetDir + "/" + t + " > " + '/home/gdifolco/ps11/dataset/41_tags/' + dest + " && scp -P 8080 /home/gdifolco/ps11/dataset/41_tags/" + dest + " black@82.231.123.182:/usr/home/black/cours_if/ps11/webextract/dataset/41_tags/" + dest + " && rm /home/gdifolco/ps11/dataset/41_tags/" + dest
    # end
end
