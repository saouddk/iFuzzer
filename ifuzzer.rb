require 'highline'
require 'cli-console'
require_relative 'core/dashboard'

class ShellUI
    private
    extend CLI::Task

    public

    usage 'Usage: load <adapter>'
    desc 'Load Adapters'
    def load(params)
      puts "loading adapter #{params[0]}..."
    end

    usage 'Usage: set <var> <val>'
    desc 'Set module options'

    def set(params)
        puts "setting #{params[0]} to #{params[1]}..."
    end

    usage 'Usage: use <fuzzer-name>'
    desc 'Use a certain fuzzer'

    def use(params)
        puts "using the intelligentFuzzer..."
    end

    usage 'Usage: search <string>'
    desc 'Search for fuzzers, books, and adapters'

    def search(params)
        puts "searching for #{params[0]}..."
    end

    usage 'Usage: show <string>'
    desc 'show fuzzer types, book recipes, and adapters'

    def show(params)
        puts "showing #{params[0]}..."
    end

end

io = HighLine.new
shell = ShellUI.new
console = CLI::Console.new(io)

console.addCommand('load', shell.method(:load), 'load $adapter')
console.addCommand('use', shell.method(:use), 'use $fuzzer')
console.addCommand('search', shell.method(:search), 'search $term')
console.addCommand('set', shell.method(:set), 'set module options')
console.addCommand('show', shell.method(:show), 'show books, adapters, and fuzzers')
console.addHelpCommand('help', 'Help')
console.addExitCommand('exit', 'Exit from program')
console.addAlias('quit', 'exit')

puts "
    
    
    
     _)   _|                              
      |  |    |   | _  / _  /   _ \   __| 
      |  __|  |   |   /    /    __/  |    
     _| _|   \__,_| ___| ___| \___| _|    
                                      


"
puts "    [ifuzzer v0.0.1, @saouddk, @codecor]"
puts ""
puts ""
puts "[#{printModuleCount('adapters')}] book modules"
puts "[#{printModuleCount('books')}] adapter modules"
puts "[#{printModuleCount('fuzzers')}] fuzzer modules"
puts ""
console.start("%s> ",[Dir.method(:pwd)])

