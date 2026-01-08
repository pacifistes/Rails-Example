class Booking < ApplicationRecord
  belongs_to :vehicle
  belongs_to :customer, class_name: "User"
end
