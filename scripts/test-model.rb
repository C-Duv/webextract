require 'yaml'
require_relative 'features'

model = YAML.parse(STDIN.read).to_ruby

####
ARGV.each do |file|
    IO.readlines(file).each do |line|
        line = line.gsub
        p line
    end
end
