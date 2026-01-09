require "test_helper"

class VehiclesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @vehicle = vehicles(:tesla_model3_2020)
    @car_vehicle = vehicles(:tesla_model3_2020)
    @motorbike_vehicle = vehicles(:honda_sportbike_2022)
  end

  test "should get index" do
    sign_in_as(users(:customer))
    get vehicles_url
    assert_response :success
  end

  test "should get new" do
    sign_in_as(users(:admin))
    get new_vehicle_url
    assert_response :success
  end

  test "should create vehicle" do
    sign_in_as(users(:admin))
    assert_difference("Vehicle.count") do
      post vehicles_url, params: { vehicle: { description: "Test car", price_by_day: 100, vehicle_type: "CAR", year_of_production: 2023, car_attributes: { brand: "TESLA", model: "MODEL_3", seats: 5, fuel_type: "ELECTRIC", gearbox: "AUTOMATIC", engine_cc: 0 } } }
    end

    assert_redirected_to vehicle_url(Vehicle.last)
  end

  test "should show vehicle" do
    sign_in_as(users(:customer))
    get vehicle_url(@vehicle)
    assert_response :success
  end

  test "should get edit" do
    sign_in_as(users(:admin))
    get edit_vehicle_url(@vehicle)
    assert_response :success
  end

  test "should update vehicle" do
    sign_in_as(users(:admin))
    patch vehicle_url(@vehicle), params: { vehicle: @vehicle.attributes.symbolize_keys.slice(:description, :price_by_day, :year_of_production).merge(description: "Updated description") }
    assert_redirected_to vehicle_url(@vehicle)
  end

  test "should destroy vehicle" do
    sign_in_as(users(:admin))
    # Use a vehicle without bookings to avoid foreign key constraint
    vehicle_to_destroy = vehicles(:tesla_model3_2019)
    assert_difference("Vehicle.count", -1) do
      delete vehicle_url(vehicle_to_destroy)
    end

    assert_redirected_to vehicles_url
  end

  # Permission tests for customer
  test "customer should not be able to access new vehicle page" do
    sign_in_as(users(:customer))
    get new_vehicle_url
    assert_redirected_to vehicles_url
    assert_equal "You don't have permission to create vehicles.", flash[:alert]
  end

  test "customer should not be able to create vehicle" do
    sign_in_as(users(:customer))
    assert_no_difference("Vehicle.count") do
      post vehicles_url, params: { vehicle: { description: "Test car", price_by_day: 100, vehicle_type: "CAR", year_of_production: 2023, car_attributes: { brand: "TESLA", model: "MODEL_3", seats: 5, fuel_type: "ELECTRIC", gearbox: "AUTOMATIC", engine_cc: 0 } } }
    end
    assert_redirected_to vehicles_url
    assert_equal "You don't have permission to create vehicles.", flash[:alert]
  end

  test "customer should not be able to edit vehicle" do
    sign_in_as(users(:customer))
    get edit_vehicle_url(@vehicle)
    assert_redirected_to vehicles_url
    assert_equal "You don't have permission to edit vehicles.", flash[:alert]
  end

  test "customer should not be able to update vehicle" do
    sign_in_as(users(:customer))
    patch vehicle_url(@vehicle), params: { vehicle: { description: "Updated description" } }
    assert_redirected_to vehicles_url
    assert_equal "You don't have permission to edit vehicles.", flash[:alert]
  end

  # Permission tests for admin
  test "admin should be able to create car" do
    sign_in_as(users(:admin))
    assert_difference("Vehicle.count") do
      post vehicles_url, params: { vehicle: { description: "Test car", price_by_day: 100, vehicle_type: "CAR", year_of_production: 2023, car_attributes: { brand: "TESLA", model: "MODEL_3", seats: 5, fuel_type: "ELECTRIC", gearbox: "AUTOMATIC", engine_cc: 0 } } }
    end
    assert_redirected_to vehicle_url(Vehicle.last)
  end

  test "admin should be able to create motorbike" do
    sign_in_as(users(:admin))
    assert_difference("Vehicle.count") do
      post vehicles_url, params: { vehicle: { description: "Test motorbike", price_by_day: 50, vehicle_type: "MOTOR_BIKE", year_of_production: 2023, motorbike_attributes: { brand: "HONDA", model: "SPORTBIKE", engine_cc: 600, has_sidecar: false } } }
    end
    assert_redirected_to vehicle_url(Vehicle.last)
  end

  test "admin should be able to edit car" do
    sign_in_as(users(:admin))
    get edit_vehicle_url(@car_vehicle)
    assert_response :success
  end

  test "admin should be able to edit motorbike" do
    sign_in_as(users(:admin))
    get edit_vehicle_url(@motorbike_vehicle)
    assert_response :success
  end

  test "admin should be able to update car" do
    sign_in_as(users(:admin))
    patch vehicle_url(@car_vehicle), params: { vehicle: @car_vehicle.attributes.symbolize_keys.slice(:description, :price_by_day, :year_of_production).merge(description: "Updated car description") }
    assert_redirected_to vehicle_url(@car_vehicle)
  end

  test "admin should be able to update motorbike" do
    sign_in_as(users(:admin))
    patch vehicle_url(@motorbike_vehicle), params: { vehicle: @motorbike_vehicle.attributes.symbolize_keys.slice(:description, :price_by_day, :year_of_production).merge(description: "Updated motorbike description") }
    assert_redirected_to vehicle_url(@motorbike_vehicle)
  end

  # Permission tests for car_manager
  test "car_manager should be able to create car" do
    sign_in_as(users(:car_manager))
    assert_difference("Vehicle.count") do
      post vehicles_url, params: { vehicle: { description: "Test car", price_by_day: 100, vehicle_type: "CAR", year_of_production: 2023, car_attributes: { brand: "TESLA", model: "MODEL_3", seats: 5, fuel_type: "ELECTRIC", gearbox: "AUTOMATIC", engine_cc: 0 } } }
    end
    assert_redirected_to vehicle_url(Vehicle.last)
  end

  test "car_manager should not be able to create motorbike" do
    sign_in_as(users(:car_manager))
    assert_no_difference("Vehicle.count") do
      post vehicles_url, params: { vehicle: { description: "Test motorbike", price_by_day: 50, vehicle_type: "MOTOR_BIKE", year_of_production: 2023, motorbike_attributes: { brand: "HONDA", model: "SPORTBIKE", engine_cc: 600, has_sidecar: false } } }
    end
    assert_redirected_to vehicles_url
    assert_equal "You don't have permission to create this type of vehicle.", flash[:alert]
  end

  test "car_manager should be able to edit car" do
    sign_in_as(users(:car_manager))
    get edit_vehicle_url(@car_vehicle)
    assert_response :success
  end

  test "car_manager should not be able to edit motorbike" do
    sign_in_as(users(:car_manager))
    get edit_vehicle_url(@motorbike_vehicle)
    assert_redirected_to vehicle_url(@motorbike_vehicle)
    assert_equal "You don't have permission to edit this type of vehicle.", flash[:alert]
  end

  test "car_manager should be able to update car" do
    sign_in_as(users(:car_manager))
    patch vehicle_url(@car_vehicle), params: { vehicle: @car_vehicle.attributes.symbolize_keys.slice(:description, :price_by_day, :year_of_production).merge(description: "Updated car description") }
    assert_redirected_to vehicle_url(@car_vehicle)
  end

  test "car_manager should not be able to update motorbike" do
    sign_in_as(users(:car_manager))
    patch vehicle_url(@motorbike_vehicle), params: { vehicle: @motorbike_vehicle.attributes.symbolize_keys.slice(:description, :price_by_day, :year_of_production).merge(description: "Updated motorbike description") }
    assert_redirected_to vehicle_url(@motorbike_vehicle)
    assert_equal "You don't have permission to edit this type of vehicle.", flash[:alert]
  end

  # Permission tests for motor_bike_manager
  test "motor_bike_manager should be able to create motorbike" do
    sign_in_as(users(:motor_bike_manager))
    assert_difference("Vehicle.count") do
      post vehicles_url, params: { vehicle: { description: "Test motorbike", price_by_day: 50, vehicle_type: "MOTOR_BIKE", year_of_production: 2023, motorbike_attributes: { brand: "HONDA", model: "SPORTBIKE", engine_cc: 600, has_sidecar: false } } }
    end
    assert_redirected_to vehicle_url(Vehicle.last)
  end

  test "motor_bike_manager should not be able to create car" do
    sign_in_as(users(:motor_bike_manager))
    assert_no_difference("Vehicle.count") do
      post vehicles_url, params: { vehicle: { description: "Test car", price_by_day: 100, vehicle_type: "CAR", year_of_production: 2023, car_attributes: { brand: "TESLA", model: "MODEL_3", seats: 5, fuel_type: "ELECTRIC", gearbox: "AUTOMATIC", engine_cc: 0 } } }
    end
    assert_redirected_to vehicles_url
    assert_equal "You don't have permission to create this type of vehicle.", flash[:alert]
  end

  test "motor_bike_manager should be able to edit motorbike" do
    sign_in_as(users(:motor_bike_manager))
    get edit_vehicle_url(@motorbike_vehicle)
    assert_response :success
  end

  test "motor_bike_manager should not be able to edit car" do
    sign_in_as(users(:motor_bike_manager))
    get edit_vehicle_url(@car_vehicle)
    assert_redirected_to vehicle_url(@car_vehicle)
    assert_equal "You don't have permission to edit this type of vehicle.", flash[:alert]
  end

  test "motor_bike_manager should be able to update motorbike" do
    sign_in_as(users(:motor_bike_manager))
    patch vehicle_url(@motorbike_vehicle), params: { vehicle: { description: "Updated motorbike description", price_by_day: @motorbike_vehicle.price_by_day, year_of_production: @motorbike_vehicle.year_of_production } }
    assert_redirected_to vehicle_url(@motorbike_vehicle)
  end

  test "motor_bike_manager should not be able to update car" do
    sign_in_as(users(:motor_bike_manager))
    patch vehicle_url(@car_vehicle), params: { vehicle: { description: "Updated car description", price_by_day: @car_vehicle.price_by_day, year_of_production: @car_vehicle.year_of_production } }
    assert_redirected_to vehicle_url(@car_vehicle)
    assert_equal "You don't have permission to edit this type of vehicle.", flash[:alert]
  end
end
