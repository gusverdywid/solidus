Factory.define :shipping_method do |f|
  f.zone {|a| Zone.find_by_name("GlobalZone") || a.association(:global_zone) }
  f.name 'UPS Ground'
  #f.display_on :back_end
  f.after_create {|shipping_method| shipping_method.calculator = Factory(:calculator,
                                                                         :calculable =>  shipping_method) }
end

Factory.define :free_shipping_method, :class => ShippingMethod do |f|
  f.zone {|a| Zone.find_by_name("GlobalZone") || a.association(:global_zone) }
  f.name 'UPS Ground'
  f.after_create {|shipping_method| shipping_method.calculator = Factory(:no_amount_calculator,
                                                                         :calculable => shipping_method) }
end
