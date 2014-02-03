require 'nokogiri'
require_relative 'features'

doc = Nokogiri::HTML(STDIN.read)


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

    @features.each do |name, exp|
        line << name + "=" + e.xpath(exp).to_s
    end

    puts line.join(" ")
end
