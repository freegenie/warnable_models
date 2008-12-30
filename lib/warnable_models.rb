# WarnableModels

module Exelab

  module WarnableModels
    
    def self.included(base)
      base.send :extend, ClassMethods
    end

    module ClassMethods

      def acts_as_warnable
        # attr_accessor :warnings
        send :include, InstanceMethods
      end
    end

    module InstanceMethods
      def warnings
        @_warnings ||= Hash.new 
      end
      
      def warn(k,v)
        @_warnings ||= Hash.new 
        @_warnings[k] = v
      end
      
      def has_warnings? 
        warnings.size > 0 
      end

    end

  end

end
