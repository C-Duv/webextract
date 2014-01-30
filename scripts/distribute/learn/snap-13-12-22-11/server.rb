require 'socket'
require 'timeout'
require 'digest/md5'

$m = Mutex.new

def getJob(hash)
    $m.synchronize {
        f = IO.readlines(ARGV[0])
        f.each_with_index do |l, i|
            unless l =~ /^DO/
                f[i] = "DO" + hash + " " + l
                IO.write(ARGV[0], f.join(""))
                return l
            end
        end
        return false
    }
end

def unvalidateJob(hash)
    $m.synchronize {
        f = IO.readlines(ARGV[0])
        f.each_with_index do |l, i|
            if l =~ /^DO#{hash}/
                f[i] = l[(hash.size + 3)..-1]
                IO.write(ARGV[0], f.join(""))
                return l
            end
        end
        return false
    }
end
# puts unvalidateJob('2483b516178bec76e05311e5bb3be4df')
def validateJob(hash)
    $m.synchronize {
        f = IO.readlines(ARGV[0])
        f.each_with_index do |l, i|
            if l =~ /^DO#{hash}/
                f.delete_at(i)
                IO.write(ARGV[0], f.join(""))
                return l
            end
        end
        return false
    }
end

def countJob
    $m.synchronize {
        f = IO.readlines(ARGV[0])
        i = 0
        f.each do |l|
            i = i + 1 unless l =~ /^DO/
        end
        return i
    }
end

clients = []
server = TCPServer.open(2000)
inc = 0
while countJob > 0 && inc < 5
    if countJob == 0
        inc = inc + 1
    else
        inc = 0
    end

    begin
        timeout(30) do
            clients << Thread.start(server.accept) do |client|
                puts "Nouveau client"
                id = " 0"

                loop do
                    ask = client.gets.strip
                    case ask
                        when "GET"
                            id = Digest::MD5.new.hexdigest("%10.6f" % Time.now.to_f)
                            job = getJob(id)
                            if job
                                client.puts job
                                puts job
                            else
                                client.close
                                Thread.exit
                            end
                        when "OK"
                            validateJob(id)
                            id = " 0"
                        when "KO"
                            unvalidateJob(id)
                            id = " 0"
                        when "QUIT"
                            client.close
                            Thread.exit
                    end
                end
            end
        end
    rescue Timeout::Error
    end
end

sleep 60 while clients.select(&:alive?).size > 0

puts "End"
