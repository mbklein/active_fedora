require 'forwardable'

module ActiveFedora
  class DatastreamHash
    extend Forwardable

    # delegate instance methods from everything up to, but not including, Object
    delegates = Hash.ancestors.slice(0,Hash.ancestors.find_index { |m| m == Object })
    methods_to_delegate = delegates.collect { |m| m.instance_methods(false) }.flatten.uniq
    def_delegators :@hash, *methods_to_delegate
    
    def initialize (obj, &block)
      @obj = obj
      @hash = Hash.new &block
    end

    def [] (key)
      if key == 'DC' && !has_key?(key)
        ds = Datastream.new(@obj.inner_object, key, :controlGroup=>'X')
        self[key] = ds
      end
      @hash[key]
    end 

    def []= (key, val)
      @obj.inner_object.datastreams[key]=val
      @hash[key]=val
    end

    def freeze
      each_value do |datastream|
        datastream.freeze
      end
      @hash.freeze
      super
    end
  end
end
