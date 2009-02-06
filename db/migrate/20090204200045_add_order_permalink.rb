class AddOrderPermalink < ActiveRecord::Migration
  def self.up
    add_index :orders, :number
    Order.all.each do |order|
      next unless order.number.is_integer? || order.number.starts_with?("0")
      order.number = "R#{order.number}"
      order.save
    end      
  end

  def self.down
    remove_index :orders, :number
  end
end
