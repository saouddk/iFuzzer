require 'optparse'
require 'ostruct'

DEBUG=1

def debug(str)
    if DEBUG==1
        puts ":: #{str}"
    end
end

# -- main --

# init options struct to store flag args
options = OpenStruct.new

OptionParser.new do |opts|
    opts.banner += " [arguments...]"
    opts.separator "fuzzer framework written in ruby"
    opts.version = "0.0.3"

    opts.on('-b', '--book BOOK', 'The BOOK') { |o| options.fuzz_book = o }
    opts.on('-f', '--fuzzer_type FUZZTYPE', 'The type of fuzzer') { |o| options.fuzz_type = o }
    opts.on('-a', '--adapter_name ADAPTERNAME', 'Adapter Type') { |o| options.adap_type = o }
    #opts.on('-c', '--count COUNT', 'Count of executions') { |o| options.count = o }

    begin
        opts.parse!
    rescue OptionParser::ParseError => error
        $stderr.puts error
        $stderr.puts "(-h will show valid options)"
        exit 1
    end
end

if options.fuzz_book.nil? || options.fuzz_type.nil? 
    $stderr.puts "error: missing arguments"
    $stderr.puts "(-h will show valid options)"
    exit 1
end

debug("starting operation")

# required 
fbook = options.fuzz_book
ftype = options.fuzz_type

# optional
fadapter = "noval" if (fadapter = options.adap_type).nil?
fcount = "noval" if (fcount = options.count).nil?

debug("book=#{fbook} | type=#{ftype}")
