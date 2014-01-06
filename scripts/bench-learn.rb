l =  Dir.entries(ARGV[0]).select { |entry|
    File.directory? File.join(ARGV[0], entry) and !(entry =='.' || entry == '..')
}

def combinate(l)
    return [] if l.size == 0
    a = []
    l.each do |e|
        s = combinate(l - [e])
        s.each do |c|
            a << c.unshift(e)
        end
    end
    a = a + [l]
    return a
end

def combinaisons(l)
    combinate(l).uniq
end

cs = combinaisons(l)
cs.each do |c|
    puts c.inspect
end
puts cs.size
