require_relative 'core'

# Class: DataStream
# ----------------------------------------------------------------------------------------
# This class is responsible for creating blueprints and mapping child classes properly.
# ----------------------------------------------------------------------------------------

class Blueprint < Core
  attr_accessor :descendants
  attr_accessor :inherited_by

  def self.inherited(subclass)
    @inherited_by = subclass
    super
  end

  def initialize
    @descendants ||= []
    descendants
  end

  def descendants
    #Get class descendants

    if @descendants.length == 0
      ObjectSpace.each_object(::Class).select do |klass|
        @descendants << klass if klass.to_s.start_with?(self.class.to_s) &&
                                 klass.to_s.length > self.class.to_s.length
      end
    end

    @descendants
  end

  def output
    #Output from all child classes
    output = ''

    @descendants.reverse.each do |descendant_class|
      output += descendant_class.new.output
    end

    output
  end

end