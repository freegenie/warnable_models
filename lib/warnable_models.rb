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
        after_save :run_warnings
        before_save :clear_warnings
      end
    end

    module InstanceMethods
      def warnings
        @warnings ||= run_run_warnings
      end

      def clear_warnings
        @warnings.clear if @warnings
      end

      def run_run_warnings
        @warnings ||= Exelab::WarnableModels::Warnings.new
        begin
          self.run_warnings
        rescue ::NoMethodError => e
          raise e, "You must implement a 'run_warnings' method on your model"
        end
        @warnings
      end
    end

  end

end
