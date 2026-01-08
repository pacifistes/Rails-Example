# == Schema Information
#
# Table name: bookings
#
#  id            :integer          not null, primary key
#  from_date     :date
#  status        :string
#  status_reason :text
#  to_date       :date
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  customer_id   :integer          not null
#  vehicle_id    :integer          not null
#
# Indexes
#
#  index_bookings_on_customer_id  (customer_id)
#  index_bookings_on_vehicle_id   (vehicle_id)
#
# Foreign Keys
#
#  customer_id  (customer_id => users.id)
#  vehicle_id   (vehicle_id => vehicles.id)
#
class Booking < ApplicationRecord
  belongs_to :vehicle
  belongs_to :customer, class_name: "User"
end
