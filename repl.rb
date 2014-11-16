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

  input = gets.chomp # "chomp" to get rid of newline at the end
  exit if input == "exit"

  parser = Scheme::Parser.new(input)

  root = parser.parse_next_exp
  while root
    root.evaluate(global_environment).pprint(0)
    root = parser.parse_next_exp
  end

  puts
end
