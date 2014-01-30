require 'nokogiri'

doc = Nokogiri::HTML(STDIN.read)

props = {
  "parProd"    => 'number(contains(parent::*/@class,"prod"))',
  "ancProd"    => 'count(ancestor::*[contains(@class,"prod")])',
  "ancDesc"    => 'count(ancestor::*[contains(@class,"desc")])',
  "selfProd"   => 'number(contains(@class,"prod"))',
  "selfDesc"   => 'number(contains(@class,"desc"))',
  "selfCurr"   => 'number(contains(text(),"£") or contains(text(),"€")  or contains(text(),"$") or contains(text(), "EUR"))',
  "contDesc"   => 'number(contains(text(),"Desc") or contains(text(),"desc"))',
  "selfEl"     => 'local-name(.)',
  "parEl"      => 'local-name(..)',
  "selfIP"     => '@itemprop',
  "selfClass"  => '@class',
  "parClass"   => '../@class',
  "selfDepth"  => 'count(ancestor::*)',
  "selfChilds" => 'count(descendant::*)',
  "inHn"       => 'ancestor-or-self::h1 or ancestor-or-self::h2 or ancestor-or-self::h3',
}.select { |k, _| ARGV.include?(k) }

####
# Search for nodes by xpath
doc.xpath('/*/*/*/*//*[self::div or self::p or self::span or self::h1 or self::h2 or self::h3]').each do |e|
    label = e.attr("data-tess-label")
    line = []
    if label
        line << label
    else
        line << "other"
    end

    props.each do |name, exp|
        line << name + "=" + e.xpath(exp).to_s
    end

    puts line.join(" ")
end
