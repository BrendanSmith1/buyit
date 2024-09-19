Product.destroy_all
puts 'Deleting previous products...'

puts 'Creating 20 products...'
20.times do
  Product.create!(title: Faker::Appliance.equipment, price: Faker::Number.decimal(l_digits: 2),
                  stock_quantity: Faker::Number.number(digits: 2), category: Faker::Appliance.brand,
                  description: Faker::Lorem.paragraph,
                  image_url: Faker::LoremFlickr.image(size: '300x300', search_terms: ['product']))
end

puts 'Finished!'
