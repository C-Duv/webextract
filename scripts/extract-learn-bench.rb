f = STDIN.read
its = f.scan(/Iteration #(\d+) /)
it = its[its.size - 1][0]
time = f.match(/Total seconds required for training: (\d*\.*\d*)/)[1]

puts it + " | " + time
