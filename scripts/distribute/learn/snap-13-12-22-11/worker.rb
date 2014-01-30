require 'digest/md5'
require 'lockfile'

$lockfile = Lockfile.new 'work.lock'

def getJob(hash)
    begin
        $lockfile.lock
        f = IO.readlines(ARGV[0])
        f.each_with_index do |l, i|
            unless l =~ /^DO/
                f[i] = "DO" + hash + " " + l
                IO.write(ARGV[0], f.join(""))
                return l
            end
        end
        return false
    ensure
        $lockfile.unlock
    end
end

def unvalidateJob(hash)
    begin
        $lockfile.lock
        f = IO.readlines(ARGV[0])
        f.each_with_index do |l, i|
            if l =~ /^DO#{hash}/
                f[i] = l[(hash.size + 3)..-1]
                IO.write(ARGV[0], f.join(""))
                return l
            end
        end
        return false
    ensure
        $lockfile.unlock
    end
end
# puts unvalidateJob('2483b516178bec76e05311e5bb3be4df')
def validateJob(hash)
    begin
        $lockfile.lock
        f = IO.readlines(ARGV[0])
        f.each_with_index do |l, i|
            if l =~ /^DO#{hash}/
                f.delete_at(i)
                IO.write(ARGV[0], f.join(""))
                return l
            end
        end
        return false
    ensure
        $lockfile.unlock
    end
end

puts "Begin"
id = " 0"

loop do
    id = Digest::MD5.new.hexdigest("%10.6f" % Time.now.to_f)
    cmd = getJob(id)
    break if !cmd
    if system(cmd)
        validateJob(id)
        id = " 0"
    else
        unvalidateJob(id)
        id = " 0"
    end
end

puts "End"
