require 'paperclip/geometry'
module Paperclip
  module ClassMethods
    # Places ActiveRecord-style validations on the width of the file assigned. The
    # possible options are:
    # * +in+: a Range of pixels (i.e. +10..100+),
    # * +less_than+: equivalent to :in => 0..options[:less_than]
    # * +greater_than+: equivalent to :in => options[:greater_than]..Infinity
    # * +message+: error message to display, use :min and :max as replacements
    def validates_attachment_width name, options = {}
      min     = options[:greater_than] || (options[:in] && options[:in].first) || 0
      max     = options[:less_than]    || (options[:in] && options[:in].last)  || (1.0/0)
      range   = (min..max)
      message = options[:message] || "file width must be between :min and :max pixels."

      attachment_definitions[name][:validations][:width] = lambda do |attachment, instance|
        if attachment.queued_for_write[:original] && !range.include?( Geometry.from_file(attachment.queued_for_write[:original]).width.to_i )
          message.gsub(/:min/, min.to_s).gsub(/:max/, max.to_s)
        end
      end
    end

    # Places ActiveRecord-style validations on the height of the file assigned. The
    # possible options are:
    # * +in+: a Range of pixels (i.e. +1..1.megabyte+),
    # * +less_than+: equivalent to :in => 0..options[:less_than]
    # * +greater_than+: equivalent to :in => options[:greater_than]..Infinity
    # * +message+: error message to display, use :min and :max as replacements
    def validates_attachment_height name, options = {}
      min     = options[:greater_than] || (options[:in] && options[:in].first) || 0
      max     = options[:less_than]    || (options[:in] && options[:in].last)  || (1.0/0)
      range   = (min..max)
      message = options[:message] || "file height must be between :min and :max pixels."

      attachment_definitions[name][:validations][:height] = lambda do |attachment, instance|
        if attachment.queued_for_write[:original] && !range.include?( Geometry.from_file(attachment.queued_for_write[:original]).height.to_i )
          message.gsub(/:min/, min.to_s).gsub(/:max/, max.to_s)
        end
      end
    end
  end
end