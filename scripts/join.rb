require 'nokogiri'

if ARGV.size != 1
    puts "usage: ruby join.rb <INSTANCE_FILE>"
    exit
end

inst = IO::readlines(ARGV[0])
line = 0

doc = Nokogiri::HTML(STDIN.read)

####
# Search for nodes by xpath
doc.xpath('/*/*/*/*//*[self::div or self::p or self::span or self::h1 or self::h2 or self::h3]').each do |e|
    label = inst[line].split(' ')[0]
    e["data-tess-label"] = label if label && label != 'other'
    line = line + 1
end

puts doc
