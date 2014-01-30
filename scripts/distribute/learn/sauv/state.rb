last = ''
lastC = ''

STDIN.readlines.each do |l|
    c = l.split(':')[0]
    puts last if c != lastC && last.size > 0
    last = l
    lastC = c
end

puts last
