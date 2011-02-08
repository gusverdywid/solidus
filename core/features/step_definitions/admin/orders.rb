Given /^custom line items associated with products$/ do
  Order.all.each do |order|
    Factory(:line_item, :order => order)
  end
end

Given /^all orders are deleted$/ do
  Order.delete_all
end
Given /^all line items are deleted$/ do
  LineItem.delete_all
end

When /^I follow the first admin_edit_order link$/ do
  order = Order.order('completed_at desc').first
  title = "admin_edit_order_#{order.id}"
  click_link(title)
end

Then /^I should see listing orders tabular attributes with completed_at descending$/ do
  output = tableish('table#listing_orders tr', 'td,th')
  data = output[0]
  data[0].should match(/Order Date/)
  data[1].should == "Order"
  data[2].should == "Status"
  data[3].should == "Payment State"
  data[4].should == "Shipment State"
  data[5].should == "Customer"
  data[6].should == "Total"

  data = output[1]
  data[0].should == Order.limit(1).order('completed_at desc').to_a.first.completed_at.strftime('%Y-%m-%d')
end

Then /^I should see listing orders tabular attributes with completed_at ascending$/ do
  output = tableish('table#listing_orders tr', 'td,th')
  data = output[1]
  data[0].should == Order.limit(1).order('completed_at asc').to_a.first.completed_at.strftime('%Y-%m-%d')
end

Then /^I should see listing orders tabular attributes with order number ascending$/ do
  output = tableish('table#listing_orders tr', 'td,th')
  data = output[1]
  data[1].should == Order.limit(1).order('number asc').to_a.first.number
end

Then /^I should see listing orders tabular attributes with order number descending$/ do
  output = tableish('table#listing_orders tr', 'td,th')
  data = output[1]
  data[1].should == Order.limit(1).order('number desc').to_a.first.number
end

Then /^I should see listing orders tabular attributes with search result 1$/ do
  output = tableish('table#listing_orders tr', 'td,th')
  puts output.inspect
  data = output[1]
  data[1].should == 'R100'
  output.size.should == 2
end

Then /^I should see listing orders tabular attributes with search result 2$/ do
  output = tableish('table#listing_orders tr', 'td,th')
  data = output[1]
  data[1].should == 'R100'
  output.size.should == 2
end

Given /^the custom address exists for the given orders$/ do
  orders = Order.order('id asc').all
  raise 'there should be only three ordres' unless Order.count == 3

  o = orders[0]
  address = Factory(:address, :firstname => 'john')
  o.bill_address = address
  o.ship_address = address
  o.save

  o = orders[1]
  address = Factory(:address, :firstname => 'john')
  address = Factory(:address, :firstname => 'mary')
  o.bill_address = address
  o.ship_address = address
  o.save

  o = orders[2]
  address = Factory(:address, :firstname => 'angelina')
  o.bill_address = address
  o.ship_address = address
  o.save
end
