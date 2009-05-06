class AddInvoiceToCart < ActiveRecord::Migration
  def self.up
    add_column :carts, :invoice, :string
  end

  def self.down
    remove_column :carts, :invoice
  end
end
