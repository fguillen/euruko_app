class CartsEvent < ActiveRecord::Base
  belongs_to :cart
  belongs_to :event
end
