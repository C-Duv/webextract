require 'nokogiri'

features = {
  "parProd"    => 'number(contains(parent::*/@class,"prod"))',
  "ancProd"    => 'count(ancestor::*[contains(@class,"prod")])',
  "ancDesc"    => 'count(ancestor::*[contains(@class,"desc")])',
  "selfProd"   => 'number(contains(@class,"prod"))',
  "selfDesc"   => 'number(contains(@class,"desc"))',
  "selfCurr"   => 'number(contains(text(),"£") or contains(text(),"€")  or contains(text(),"$") or contains(text(), "EUR"))',
  "contDesc"   => 'number(contains(text(),"Desc") or contains(text(),"desc"))',
  # "selfEl"     => 'local-name(.)',
  # "parEl"      => 'local-name(..)',
  # "selfIP"     => '@itemprop',
  # "selfClass"  => '@class',
  # "parClass"   => '../@class',
  "selfDepth"  => 'count(ancestor::*)',
  "selfChilds" => 'count(descendant::*)',
  "inHn"       => 'number(ancestor-or-self::h1 or ancestor-or-self::h2 or ancestor-or-self::h3)',
}

maxs = {}
mins = {}
accsN = {}
nbN = 0
features.each do |k, _|
    maxs[k] = 0
    mins[k] = 0
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
                features.each do |k, _|
                    accsP[label][k] = 0
                end
            end

            features.each do |name, exp|
                accsP[label][name] = accsP[label][name] + e.xpath(exp).to_f
            end
        else
            nbN = nbN + 1

            features.each do |name, exp|
                accsN[name] = accsN[name] + e.xpath(exp).to_f
            end
        end

        features.each do |name, exp|
            v = e.xpath(exp).to_f
            mins[name] = [mins[name], v].min
            maxs[name] = [maxs[name], v].max
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
        discs[label][f] = ((v - moysN[f]).abs)/(maxs[f] - mins[f])
        discs[label][f] = 0 if discs[label][f].nan?
    end
end

discs.each do |k, fs|
    discs[k] = discs[k].sort_by { |_, v| v }.reverse
end

discs.each do |k, fs|
    discs[k] = fs[0..2].map { |f, _| f }
    puts "#{k} : #{fs[0..2].map { |v| v.join('=') }.join(' ')}"
end

puts discs.map { |_, v| v }.flatten.uniq.join(' ')
