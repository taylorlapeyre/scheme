require_relative 'parser/parser'
require_relative 'parser/interpreter'

# REPL
################################################
puts "Scheme Interpreter v3"
puts 'Type "exit" to quit'

global_environment = Scheme::Environment.new
global_environment.define_built_in_procedures

loop do
  print "> "

  parser = Scheme::Parser.new(gets.chomp)

  root = parser.parse_next_exp
  while root
    root.evaluate(global_environment).pprint(0)
    root = parser.parse_next_exp
  end

  puts
end
