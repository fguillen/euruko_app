Factory.define :room do |f|
  f.sequence(:name) { |n| "room_name#{n}"}
end