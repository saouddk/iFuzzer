
# -- main --

# init options struct to store flag args
options = OpenStruct.new

OptionParser.new do |opts|
    opts.banner += " [arguments...]"
    opts.separator "this program blows you"
    opts.version = "0.0.3"

    opts.on('-u', '--url URL', 'The read URL') { |o| options.read_url = o }
    opts.on('-t', '--time_scope TSCOPE', 'The time scope (1/24/168)') { |o| options.time_scope = o }
    opts.on('-n', '--needle NEEDLE', 'Search key word') { |o| options.needle = o }
    opts.on('-p', '--points_gt POINTS_GT', 'Points greater than') { |o| options.points_gt = o }

    begin
        opts.parse!
    rescue OptionParser::ParseError => error
        $stderr.puts error
        $stderr.puts "(-h will show valid options)"
        exit 1
    end
end

if options.read_url.nil? || options.time_scope.nil? 
    $stderr.puts "error: missing arguments"
    $stderr.puts "(-h will show valid options)"
    exit 1
end

debug("starting operation")

input_url = options.read_url

scope_hours = options.time_scope

containstr = "noval" if (containstr = options.needle).nil?
points_gt = "noval" if (points_gt = options.points_gt).nil?

# call print send the url 
retval =  printMsg(input_url,scope_hours,containstr,points_gt)

if retval[:count] > 0
    puts retval[:msg]
    exit 0
else
    puts "getter.rb: no-msgs-to-put (#{retval[:count]})"
    exit 1
end
