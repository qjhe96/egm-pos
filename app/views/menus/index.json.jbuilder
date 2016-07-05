json.array!(@menus) do |menu|
  json.extract! menu, :id, :code, :name, :price
  json.url menu_url(menu, format: :json)
end
