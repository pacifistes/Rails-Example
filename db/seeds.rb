# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).

# Create admin user if it doesn't exist
admin = User.find_or_create_by!(email_address: "admin@example.com") do |user|
  user.password = "password"
  user.role = :admin
end

# Clear existing vehicles if you want fresh data (optional - comment out if you want to keep existing vehicles)
# Vehicle.destroy_all

# Generate 20 vehicles
vehicles_data = [
  # Cars (12 vehicles)
  { vehicle_type: "CAR", description: "Luxury electric sedan", price_by_day: 150.00, year_of_production: 2023, car: { brand: "TESLA", model: "MODEL_S", engine_cc: 0, fuel_type: "ELECTRIC", gearbox: "AUTOMATIC", seats: 5 } },
  { vehicle_type: "CAR", description: "Compact electric car", price_by_day: 80.00, year_of_production: 2024, car: { brand: "TESLA", model: "MODEL_3", engine_cc: 0, fuel_type: "ELECTRIC", gearbox: "AUTOMATIC", seats: 5 } },
  { vehicle_type: "CAR", description: "SUV electric vehicle", price_by_day: 120.00, year_of_production: 2023, car: { brand: "TESLA", model: "MODEL_X", engine_cc: 0, fuel_type: "ELECTRIC", gearbox: "AUTOMATIC", seats: 7 } },
  { vehicle_type: "CAR", description: "Compact SUV electric", price_by_day: 100.00, year_of_production: 2024, car: { brand: "TESLA", model: "MODEL_Y", engine_cc: 0, fuel_type: "ELECTRIC", gearbox: "AUTOMATIC", seats: 5 } },
  { vehicle_type: "CAR", description: "Sports electric car", price_by_day: 200.00, year_of_production: 2022, car: { brand: "TESLA", model: "ROADSTER", engine_cc: 0, fuel_type: "ELECTRIC", gearbox: "AUTOMATIC", seats: 2 } },
  { vehicle_type: "CAR", description: "Luxury sedan", price_by_day: 180.00, year_of_production: 2023, car: { brand: "MERCEDES", model: "MODEL_S", engine_cc: 2000, fuel_type: "PETROL", gearbox: "AUTOMATIC", seats: 5 } },
  { vehicle_type: "CAR", description: "Compact luxury car", price_by_day: 90.00, year_of_production: 2024, car: { brand: "MERCEDES", model: "MODEL_3", engine_cc: 1800, fuel_type: "DIESEL", gearbox: "AUTOMATIC", seats: 5 } },
  { vehicle_type: "CAR", description: "Luxury SUV", price_by_day: 140.00, year_of_production: 2023, car: { brand: "MERCEDES", model: "MODEL_X", engine_cc: 2500, fuel_type: "PETROL", gearbox: "AUTOMATIC", seats: 7 } },
  { vehicle_type: "CAR", description: "Compact luxury SUV", price_by_day: 110.00, year_of_production: 2024, car: { brand: "MERCEDES", model: "MODEL_Y", engine_cc: 2000, fuel_type: "DIESEL", gearbox: "MANUAL", seats: 5 } },
  { vehicle_type: "CAR", description: "Sports car", price_by_day: 190.00, year_of_production: 2022, car: { brand: "MERCEDES", model: "ROADSTER", engine_cc: 3000, fuel_type: "PETROL", gearbox: "MANUAL", seats: 2 } },
  { vehicle_type: "CAR", description: "Economy electric car", price_by_day: 70.00, year_of_production: 2024, car: { brand: "TESLA", model: "MODEL_3", engine_cc: 0, fuel_type: "ELECTRIC", gearbox: "AUTOMATIC", seats: 5 } },
  { vehicle_type: "CAR", description: "Premium sedan", price_by_day: 160.00, year_of_production: 2023, car: { brand: "MERCEDES", model: "MODEL_S", engine_cc: 2200, fuel_type: "DIESEL", gearbox: "AUTOMATIC", seats: 5 } },
  
  # Motorbikes (8 vehicles)
  { vehicle_type: "MOTOR_BIKE", description: "Sport motorcycle", price_by_day: 60.00, year_of_production: 2023, motorbike: { brand: "HONDA", model: "SPORTBIKE", engine_cc: 1000, has_sidecar: false } },
  { vehicle_type: "MOTOR_BIKE", description: "Cruiser motorcycle", price_by_day: 55.00, year_of_production: 2024, motorbike: { brand: "YAMAHA", model: "CRUISER", engine_cc: 1200, has_sidecar: false } },
  { vehicle_type: "MOTOR_BIKE", description: "Sport bike with sidecar", price_by_day: 75.00, year_of_production: 2023, motorbike: { brand: "KAWASAKI", model: "SPORTBIKE", engine_cc: 900, has_sidecar: true } },
  { vehicle_type: "MOTOR_BIKE", description: "Premium sport motorcycle", price_by_day: 85.00, year_of_production: 2024, motorbike: { brand: "DUCATI", model: "SPORTBIKE", engine_cc: 1100, has_sidecar: false } },
  { vehicle_type: "MOTOR_BIKE", description: "Luxury cruiser", price_by_day: 70.00, year_of_production: 2023, motorbike: { brand: "BMW", model: "CRUISER", engine_cc: 1300, has_sidecar: false } },
  { vehicle_type: "MOTOR_BIKE", description: "Classic cruiser", price_by_day: 65.00, year_of_production: 2022, motorbike: { brand: "HARLEY_DAVIDSON", model: "CRUISER", engine_cc: 1500, has_sidecar: false } },
  { vehicle_type: "MOTOR_BIKE", description: "Adventure sport bike", price_by_day: 80.00, year_of_production: 2024, motorbike: { brand: "BMW", model: "SPORTBIKE", engine_cc: 1000, has_sidecar: false } },
  { vehicle_type: "MOTOR_BIKE", description: "Cruiser with sidecar", price_by_day: 90.00, year_of_production: 2023, motorbike: { brand: "HARLEY_DAVIDSON", model: "CRUISER", engine_cc: 1600, has_sidecar: true } }
]

vehicles_data.each do |vehicle_data|
  car_data = vehicle_data.delete(:car)
  motorbike_data = vehicle_data.delete(:motorbike)
  
  vehicle = Vehicle.create!(
    vehicle_data.merge(added_by: admin)
  )
  
  if car_data
    vehicle.create_car!(car_data)
  elsif motorbike_data
    vehicle.create_motorbike!(motorbike_data)
  end
end

puts "Created #{Vehicle.count} vehicles"
puts "Created #{Car.count} cars"
puts "Created #{Motorbike.count} motorbikes"
