Product.destroy_all

20.times do
  Product.create!(title: Faker::Appliance.equipment, price: Faker::Number.decimal(l_digits: 2))
end
