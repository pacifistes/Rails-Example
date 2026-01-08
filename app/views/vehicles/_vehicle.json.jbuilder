json.extract! vehicle, :id, :vehicle_type, :description, :price_by_day, :year_of_production, :images, :added_by_id, :created_at, :updated_at
json.url vehicle_url(vehicle, format: :json)
json.images do
  json.array!(vehicle.images) do |image|
    json.id image.id
    json.url url_for(image)
  end
end
