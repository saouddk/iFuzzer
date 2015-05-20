require_relative 'core'

# Class: DataStream
# ----------------------------------------------------------------------------------------
# This class is responsible for creating the binary output from the supplied fields.
# ----------------------------------------------------------------------------------------

class Placeholder < Core
  attr_accessor :offset, :len, :value

  def initialize(*args)
    if args.length == 3
      @offset = args[0]
      @len = args[1]
      @value = args[2]
    else
      raise InvalidPlaceholder, "Invalid call to create a Placeholder object"
    end
  end
end

class DataStream < Core
  class << self
    attr_accessor :stream, :placeholders

    def data(*args)
      @stream ||= []
      @placeholders ||= []

      @stream << [args[0], args[1]] if args.length == 2
      @stream << [args[0], args[1], compute_value(*args)] if args.length == 3
    end

    def compute_value(*args)
      func_symbols = [:random, :zero] #Future: automate this, make it iterate through all methods in class and convert to symbol and add to array.
      numeric_symbols = [:total_file_size, :offset, :self_size, :numeric]  #Numeric fields to be fuzzed, could be a int32, in64, dword, etc.
      string_symbols = [:string] #String fields

      all_symbols = func_symbols + numeric_symbols + string_symbols

      name = args[0]
      len = args[1]
      value = args[2]

      if value.is_a? Symbol
        if all_symbols.include? value
          if self.method(value).arity == 1
            return self.send(value, len)
          else
            return self.method(value).call
          end
        else
          raise UnknownSymbol, "Unknown symbol supplied to value for `#{name}` field."
        end
      elsif value.is_a? Array #If array, then an explicit value must be selected from array
        insert_placeholder(:offset_current, len, value)
        return value[0]
      else
        return value
      end
    end

    def zero
      0
    end

    def total_file_size(field_length)
      #Return when code is fully compiled, hook? Inject placeholder, so that fuzzer can utilize this information when
      #parsing sample files.

      insert_placeholder(:offset_current, field_length, :total_file_size)
      field_length.times.map{0}.join
    end

    def random(field_length)
      field_length.times.map{Random.rand(9)}.join #Random 1 byte
    end

    def offset(field_length)
      field_length.times.map{Random.rand(9)}.join #Random 1 byte
    end

    def self_size(field_length)
      #This measures the initiating class size in bytes. Placeholder is placed for fuzzer to retrieve.

      insert_placeholder(:offset_current, field_length, :total_file_size)
      field_length.times.map{0}.join
    end

    def numeric(field_length)
      field_length.times.map{Random.rand(9)}.join #Random 1 byte
    end

    def insert_placeholder(*args)
      #Method: insert_placeholder(Offset location, length, method name)

      if args.length == 3
        placeholder = Placeholder.new(args[0], args[1], args[2])

        @placeholders << placeholder
        @stream << placeholder
      end
    end
  end

  def initialize(*args)
    super(*args) if args.length == 2 || args.length == 3

    self.class.stream.each do |entry|
      #Set instance variable with supplied name and value

      unless entry.is_a? Placeholder
        self.class.class_eval { attr_accessor entry[0] }
        instance_variable_set("@#{entry[0]}", entry[2].nil? ? entry[1] : entry[2])
      end
    end
  end

  def output
    #Value will always be last in array element of stream

    self.class.stream.map do |entry|
      entry.last.is_a?(String) ? entry.last.to_s : entry.last.to_i.to_s(16) unless entry.is_a? Placeholder
    end.join
  end
end