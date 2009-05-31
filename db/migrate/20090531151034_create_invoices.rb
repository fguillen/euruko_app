class CreateInvoices < ActiveRecord::Migration
  def self.up
    remove_column :carts, :invoice
    
    create_table :invoices do |t|
      t.string      :serial,  :null => false, :limit => 50
      t.string      :path,    :null => false
      t.integer     :cart_id, :null => false
      t.date        :date,    :null => false
      t.timestamps
    end
    
  end

  def self.down
    add_column :carts, :invoice, :string

    drop_table :invoices
  end
end
