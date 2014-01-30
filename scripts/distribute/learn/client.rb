require 'socket'

host = 'localhost'
port = 2000

s = TCPSocket.open(host, port)
loop {
    s.puts "GET"
    cmd = s.gets
    if !cmd
        s.close
        exit
    end
    if system(cmd)
        s.puts "OK"
    else
        s.puts "KO"
    end
}
