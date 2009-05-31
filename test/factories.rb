Factory.define :room do |f|
  f.sequence(:name) { |n| "room_name#{n}"}
end

Factory.define :invoice do |f|
  f.association :cart, :factory => :cart
  f.sequence(:serial) { |n| Kernel.sprintf( "%3d", n ) }
  f.sequence(:path) { |n| "/tmp/path#{n}" }
  f.sequence(:date) { |n| Time.now + n }
end

Factory.define :cart do |f|
  f.association :user, :factory => :user
  f.status Cart::STATUS[:ON_SESSION] # no puedo hacer esto: Post::STATUS_PUBLISHED
end

Factory.define :event do |f|
  f.sequence(:name) { |n| "name#{n}" }
  f.sequence(:description) { |n| "description#{n}" }
  f.sequence(:price_cents) { |n| n }
end

Factory.define :user do |f|
  f.sequence(:login) { |n| "login#{n}" }
  f.sequence(:name) { |n| "name#{n}" }
  f.sequence(:email) { |n| "email#{n}@example.com" }
  f.password "password"
  f.password_confirmation "password"
  f.role User::ROLE[:USER]
  f.public_profile true
end
