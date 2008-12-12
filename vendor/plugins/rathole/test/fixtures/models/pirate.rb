class Pirate < ActiveRecord::Base
  belongs_to :monkey
  has_and_belongs_to_many :monkeys
end
