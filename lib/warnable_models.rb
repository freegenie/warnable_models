# WarnableModels
require 'warnings'

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
        @warnings ||= Exelab::WarnableModels::Warnings.new
      end
      
      # def warn(k,v)
      #   @_warnings[k] = v
      # end
      
      # def has_warnings? 
      #   warnings.size > 0 
      # end

    end

  end

end
