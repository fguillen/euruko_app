require "active_record"

require "rathole"
require "rathole/extensions/fixtures"

unless defined?(RATHOLE_SUPPORTED_ADAPTERS)
  RATHOLE_SUPPORTED_ADAPTERS = %w(mysql sqlite)
end

RATHOLE_SUPPORTED_ADAPTERS.each do |adapter|
  require "rathole/extensions/active_record/connection_adapters/#{adapter}_adapter"
end
