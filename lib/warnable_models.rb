# WarnableModels
require File.dirname(__FILE__) + '/warnings'

module Freegenie

  module WarnableModels

    module ClassMethods
      
      def acts_as_warnable(options={})
        class_eval("@@warnable_options = #{options.inspect}")        
        send :include, InstanceMethods        
        before_save :load_warnings
        
      end
      
      def warnable_options
        class_eval("@@warnable_options")
      end
    end

    module InstanceMethods
                  
      def warnings        
        @warnings ||= load_warnings        
      end
      
      def clear_warnings! 
        @warnings = nil
      end
      protected 
      
      def load_warnings
        # ---------------------
        # initialize warning object
        # ---------------------        
        @warnings = Freegenie::WarnableModels::Warnings.new    
                  
        raise "warnings should be empty"  if !@warnings.empty?        
        
        if !self.methods.include? 'run_warnings'
          raise "You must implement a 'run_warnings' method on your model."
        end
        
        self.run_warnings
        
        if !self.class.warnable_options[:store_count].nil? 
          instance_eval("self.#{self.class.warnable_options[:store_count]} = #{@warnings.size}")
        end
        
        if !self.class.warnable_options[:store_yaml].nil? 
          if @warnings.size > 0 
            instance_eval("self.#{self.class.warnable_options[:store_yaml]} = \"#{@warnings.to_yaml }\" ")
          else
            instance_eval("self.#{self.class.warnable_options[:store_yaml]} = nil ")
          end
        end      
          
        @warnings
      end
    end

    def self.included(receiver)      
      receiver.extend         ClassMethods
      receiver.send :include, InstanceMethods
    end
  end

end
