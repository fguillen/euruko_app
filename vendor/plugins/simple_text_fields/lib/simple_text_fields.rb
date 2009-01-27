require 'actionpack'
require 'action_controller'
# require 'ruby-debug'


# ActsWithoutScripts
module ActiveRecord
  module SimpleTextFields
    def self.included(base)
      base.extend(ClassMethods)
    end

    def sanitize(data)
      @html_sanitizer ||= HTML::FullSanitizer.new
      @html_sanitizer.sanitize(data)
    end
    
    module ClassMethods
      def simple_text_fields(options = {})

        fields = self.columns.select { |column| [:string,:text].include? column.type } rescue []
        fields.collect! { |column| column.name }
      
        [:only, :except].each do |selector|
          options[selector] ||= []
          options[selector] = [options[selector]].flatten
          options[selector].collect! { |option| option.to_s }
          options[selector]
        end
      
        fields = fields & options[:only] unless options[:only].blank?
        fields = fields - options[:except]
      
        fields.each do |field|
          define_method(field) do
            sanitize(self[field])
          end
        
          define_method("#{field.to_s}=") do |data|
            self[field] = sanitize(data)
          end
        end
      
      end
    end
  end
end

ActiveRecord::Base.send(:include, ActiveRecord::SimpleTextFields)