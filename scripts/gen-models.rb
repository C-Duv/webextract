require 'nokogiri'
require_relative 'features'

maxsP = {}
minsP = {}
maxsN = {}
minsN = {}
accsN = {}
nbN = 0
@features.each do |k, _|
    maxsN[k] = 0
    minsN[k] = 0
    maxsP[k] = 0
    minsP[k] = 0
    accsN[k] = 0
end

accsP = {}
nbsP = {}



####
# Search for nodes by xpath
ARGV.each do |file|
    # p IO.read(file)
    Nokogiri::HTML(IO.read(file)).xpath('/*/*/*/*//*[self::div or self::p or self::span or self::h1 or self::h2 or self::h3]').each do |e|
        label = e.attr("data-tess-label")
        if label
            nbsP[label] = (nbsP[label] || 0) + 1

            if !accsP[label]
                accsP[label] = {}
                @features.each do |k, _|
                    accsP[label][k] = 0
                end
            end

            @features.each do |name, exp|
                v = e.xpath(exp).to_f
                accsP[label][name] = accsP[label][name] + v
                minsP[name] = [minsP[name], v].min
                maxsP[name] = [maxsP[name], v].max
            end
        else
            nbN = nbN + 1

            @features.each do |name, exp|
                accsN[name] = accsN[name] + e.xpath(exp).to_f
            end
        end

        @features.each do |name, exp|
            v = e.xpath(exp).to_f
            minsN[name] = [minsN[name], v].min
            maxsN[name] = [maxsN[name], v].max
        end
    end
end

moysP = {}
accsP.each do |label, fs|
    moysP[label] = {}
    fs.each do |k, v|
        moysP[label][k] = v/nbsP[label]
    end
end

moysN = {}
accsN.each do |f, v|
    moysN[f] = v/nbN
end

discs = {}
moysP.each do |label, fs|
    discs[label] = {}
    fs.each do |f, v|
        discs[label][f] = ((v - moysN[f]).abs)/([maxsN[f], maxsP[f]].max - [minsN[f], minsP[f]].min)
        discs[label][f] = 0 if discs[label][f].nan?
    end
end

discs.each do |k, fs|
    discs[k] = discs[k].sort_by { |_, v| v }.reverse
end

discs.each do |k, fs|
    discs[k] = fs[0..2].map { |f, _| f }
    puts "#{k}:"
    fs[0..2].each do |e|
        f, v = e[0], e[1]
        puts "    #{f}:"
        puts "        minN: #{minsN[f]}"
        puts "        maxN: #{maxsN[f]}"
        puts "        avgN: #{moysN[f]}"
        puts "        minP: #{minsP[f]}"
        puts "        maxP: #{maxsP[f]}"
        puts "        avgP: #{moysP[k][f]}"
        puts "        relevance: #{v}"
    end
end

