f = STDIN.readlines
s = f.size
m = f[s-4].match(/\((\d*\.*\d*), (\d*\.*\d*),/)
precision = m[1]
recall = m[2]
time = f[s-1].match(/: (\d*\.*\d*)/)[1]

puts precision + " | " + recall + " | " + time
