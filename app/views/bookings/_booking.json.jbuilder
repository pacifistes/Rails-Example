json.extract! booking, :id, :vehicle_id, :customer_id, :from_date, :to_date, :status, :status_reason, :created_at, :updated_at
json.url booking_url(booking, format: :json)
