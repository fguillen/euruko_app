module SimplifiedPermalink

  def self.included(base)
    base.extend ClassMethods
  end

  module ClassMethods

    # Specifies the given field as using permalink.
    #
    #   class Foo < ActiveRecord::Base
    #
    #     # stores the permalink version of title on permalink
    #     permalink :title
    #
    #     # stores the permalink version of title on slug
    #     permalink :title, :slug
    #
    #   end
    #
    def permalink(field_name, permalink_field_name = 'permalink')
      before_save do |record|
        if record.send("#{permalink_field_name}").blank? and !record.send(field_name).blank?
          record.send "#{permalink_field_name}=", record.send(field_name).parameterize
        end
      end
      
      include SimplifiedPermalink::InstanceMethods
    end
  end
  
  module InstanceMethods
    def to_param
      "#{self.id}-#{self.permalink}"
    end
  end

end

ActiveRecord::Base.send :include, SimplifiedPermalink
