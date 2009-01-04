module Exelab
  module WarnableModels
    # Inspired by ActiveRecord::Errors
    class Warnings

      include Enumerable

      def initialize() # :nodoc:
        @warnings = {}
      end

      def add_to_base(msg)
        add(:base, msg)
      end

      def add(attribute, message = nil, options = {})
        message ||= :invalid
        @warnings[attribute.to_s] ||= []
        @warnings[attribute.to_s] << message
      end

      def warns?(attribute)
        !@warnings[attribute.to_s].nil?
      end

      def on(attribute)
        errors = @warnings[attribute.to_s]
        return nil if errors.nil?
        errors.size == 1 ? errors.first : errors
      end

      alias :[] :on

      def on_base
        on(:base)
      end

      def each
        @warnings.each_key { |attr| @warnings[attr].each { |msg| yield attr, msg } }
      end

      def empty?
        @warnings.empty?
      end

      def clear
        @warnings = {}
      end

      def size
        @warnings.values.inject(0) { |error_count, attribute| error_count + attribute.size }
      end

      alias_method :count, :size
      alias_method :length, :size

      def full_messages(options = {})
        full_messages = []

        @warnings.each_key do |attr|
          @warnings[attr].each do |message|
            next unless message

            if attr == "base"
              full_messages << message
            else
              full_messages << attr + ' ' + message
            end
          end
        end
        full_messages
      end

      def to_xml(options={})
        options[:root] ||= "warnings"
        options[:indent] ||= 2
        options[:builder] ||= Builder::XmlMarkup.new(:indent => options[:indent])

        options[:builder].instruct! unless options.delete(:skip_instruct)
        options[:builder].warnings do |e|
          full_messages.each { |msg| e.warning(msg) }
        end
      end
    end
  end
end
