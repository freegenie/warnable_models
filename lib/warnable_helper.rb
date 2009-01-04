module Exelab
  
  module WarnableHelper 
    
    # Clone of error_messages_for
    def warning_messages_for(*params)
      
      options = params.last.is_a?(Hash) ? params.pop.symbolize_keys : {}
      objects = params.collect {|object_name| instance_variable_get("@#{object_name}") }.compact
      count   = objects.inject(0) {|sum, object| sum + object.warnings.count }
      unless count.zero?
        html = {}
        [:id, :class].each do |key|
          if options.include?(key)
            value = options[key]
            html[key] = value unless value.blank?
          else
            html[key] = 'warningExplanation'
          end
        end

        header_message = "warning header message "

        warning_messages = objects.map {|object|
          object.warnings.map {|k,v|
            content_tag(:li, v)
          }
        }

        warnings_html = content_tag(options[:header_tag] || :h2, header_message)
        if not ( (options.has_key? :skip_intro) && options[:skip_intro])
          warnings_html << content_tag(:p, 'warnings message')
        end
        warnings_html << content_tag(:ul, warning_messages)
        content_tag(:div, warnings_html, html)
      else
        ''
      end

    end 
    
  end
  
end
    