# WarnableModels
require File.dirname(__FILE__) + '/warnings'

module Exelab

  module WarnableModels

    module ClassMethods
      def acts_as_warnable
        # attr_accessor :warnings
        send :include, InstanceMethods
        after_save :load_warnings          
      end
    end

    module InstanceMethods
      
      def warnings
        @warnings ||= load_warnings
      end

      def clear_warnings
        @warnings = Exelab::WarnableModels::Warnings.new
      end

      def load_warnings
        # ---------------------
        # initialize warning object
        # ---------------------
        clear_warnings        
        raise "warnings should be empty"  if !@warnings.empty?        
        begin
          if !self.new_record?
            self.reload
          end
        rescue ::NoMethodError => e
          raise e, "You must implement a 'run_warnings' method on your model"
        rescue => e
          raise e
        end
        raise "warnings should be empty" if !@warnings.empty?
        self.run_warnings
        @warnings
      end
    end

    def self.included(receiver)
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end

end
