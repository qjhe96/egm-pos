json.array!(@customers) do |customer|
  json.extract! customer, :id, :firstname, :lastname, :phone, :address
  json.url customer_url(customer, format: :json)
end
