ActiveRecord::Schema.define do
  create_table :monkeys do |t|
    t.column :name, :string
    t.column :created_at, :datetime
    t.column :created_on, :datetime
    t.column :updated_at, :datetime
    t.column :updated_on, :datetime
  end
  
  create_table :pirates do |t|
    t.column :catchphrase, :string
    t.column :monkey_id, :integer
    t.column :created_on, :datetime
    t.column :updated_on, :datetime
  end
  
  create_table :monkeys_pirates, :id => false do |t|
    t.column :monkey_id, :integer
    t.column :pirate_id, :integer
  end
  
  create_table :fruits do |t|
    t.column :name, :string
  end
  
  create_table :fruits_monkeys, :id => false do |t|
    t.column :fruit_id, :integer
    t.column :monkey_id, :integer
  end
end
