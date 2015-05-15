require_relative 'core'

# Class: DataStream
# ----------------------------------------------------------------------------------------
# This class is responsible for creating the binary output from the supplied fields.
# ----------------------------------------------------------------------------------------

class DataStream < Core
  class << self
    attr_accessor :stream, :placeholders

    def data(*args)
      @stream ||= []

      @stream << [args[0], args[1]] if args.length == 2
      @stream << [args[0], args[1], compute_value(args)] if args.length == 3
    end

    def compute_value(*args)
      func_symbols = [:random, :zero, :total_file_size, :offset] #Future: automate this, make it iterate through all methods in class and convert to symbol and add to array.

      name = args[0][0]
      len = args[0][1]
      value = args[0][2]

      if value.is_a? Symbol
        if func_symbols.include? value
          if self.method(value).arity == 1
            return self.send(value, len)
          else
            return self.method(value).call
          end
        else
          raise UnknownSymbol, "Unknown symbol supplied to value for `#{name}` field."
        end
      else
        return value
      end
    end

    def zero
      0
    end

    def total_file_size(field_length)
      #Return when code is fully compiled, hook? Inject placeholder, and then in output analyze?
      #Record location and placeholder and at end of output, create file size
      insert_placeholder(:offset_current, field_length, :total_file_size)
      field_length.times.map{0}.join
    end

    def random(field_length)
      field_length.times.map{Random.rand(9)}.join #Random 1 byte
    end

    def insert_placeholder(*args)
      @placeholders ||= []

      if args.length == 3
        @placeholders << [args[0], args[1], args[2]]  #Offset location, length, method name
      end
    end
  end

  def initialize(*args)
    super(*args) if args.length == 2 || args.length == 3

    self.class.stream.each do |entry|
      #Set instance variable with supplied name and value

      self.class.class_eval { attr_accessor entry[0] }
      instance_variable_set("@#{entry[0]}", entry[2].nil? ? entry[1] : entry[2])
    end
  end

  def output
    #Value will always be last in array element of stream
    self.class.stream.map do |entry|
      entry.last.is_a?(String) ? entry.last.to_s : entry.last.to_i.to_s(16)
    end.join
  end
end