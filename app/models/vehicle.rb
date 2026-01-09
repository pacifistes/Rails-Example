# == Schema Information
#
# Table name: vehicles
#
#  id                 :integer          not null, primary key
#  description        :text
#  price_by_day       :decimal(10, 2)
#  vehicle_type       :string
#  year_of_production :integer
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  added_by_id        :integer          not null
#
# Indexes
#
#  index_vehicles_on_added_by_id  (added_by_id)
#
# Foreign Keys
#
#  added_by_id  (added_by_id => users.id)
#
class Vehicle < ApplicationRecord
  belongs_to :added_by, class_name: "User"
  has_many_attached :images
  has_one :car, dependent: :destroy
  has_one :motorbike, dependent: :destroy

  accepts_nested_attributes_for :car, :motorbike

  VEHICULE_TYPES = [ "CAR", "MOTOR_BIKE" ].freeze() # freeze allow to block the list so it put the array as a constant

  validates :vehicle_type, inclusion: { in: VEHICULE_TYPES, message: "%{value} is not a valid vehicle" }

  # Scopes for filtering
  scope :filter_by_vehicle_type, ->(types) {
    types = Array(types).reject(&:blank?)
    types.empty? ? all : where(vehicle_type: types)
  }

  scope :filter_by_brand, ->(brands) {
    brands = Array(brands).reject(&:blank?)
    return all if brands.empty?
    left_joins(:car, :motorbike)
      .where("cars.brand IN (?) OR motorbikes.brand IN (?)", brands, brands)
  }

  scope :filter_by_model, ->(models) {
    models = Array(models).reject(&:blank?)
    return all if models.empty?
    left_joins(:car, :motorbike)
      .where("cars.model IN (?) OR motorbikes.model IN (?)", models, models)
  }

  scope :filter_by_price_range, ->(min_price: nil, max_price: nil) {
    scope = all
    scope = scope.where("price_by_day >= ?", min_price) if min_price.present?
    scope = scope.where("price_by_day <= ?", max_price) if max_price.present?
    scope
  }

  scope :filter_by_year, ->(min_year: nil, max_year: nil) {
    scope = all
    scope = scope.where("year_of_production >= ?", min_year) if min_year.present?
    scope = scope.where("year_of_production <= ?", max_year) if max_year.present?
    scope
  }

  scope :filter_by_fuel_type, ->(fuel_types) {
    fuel_types = Array(fuel_types).reject(&:blank?)
    return all if fuel_types.empty?
    joins(:car).where(cars: { fuel_type: fuel_types })
  }

  scope :filter_by_gearbox, ->(gearboxes) {
    gearboxes = Array(gearboxes).reject(&:blank?)
    return all if gearboxes.empty?
    joins(:car).where(cars: { gearbox: gearboxes })
  }

  # Apply all filters based on params hash
  def self.apply_filters(filters = {})
    vehicles = all

    vehicles = vehicles.filter_by_vehicle_type(filters[:vehicle_type]) if filters[:vehicle_type].present?
    vehicles = vehicles.filter_by_brand(filters[:brand]) if filters[:brand].present?
    vehicles = vehicles.filter_by_model(filters[:model]) if filters[:model].present?
    vehicles = vehicles.filter_by_price_range(
      min_price: filters[:min_price],
      max_price: filters[:max_price]
    ) if filters[:min_price].present? || filters[:max_price].present?
    vehicles = vehicles.filter_by_year(
      min_year: filters[:min_year],
      max_year: filters[:max_year]
    ) if filters[:min_year].present? || filters[:max_year].present?
    vehicles = vehicles.filter_by_fuel_type(filters[:fuel_type]) if filters[:fuel_type].present?
    vehicles = vehicles.filter_by_gearbox(filters[:gearbox]) if filters[:gearbox].present?

    vehicles
  end

  # Paginate vehicles collection
  def self.paginate_collection(vehicles, page: 1, per_page: 5)
    page = [page.to_i, 1].max
    total_count = vehicles.count
    total_pages = (total_count.to_f / per_page).ceil
    offset = (page - 1) * per_page
    paginated_vehicles = vehicles.limit(per_page).offset(offset)

    {
      vehicles: paginated_vehicles,
      current_page: page,
      total_pages: total_pages,
      total_count: total_count,
      per_page: per_page
    }
  end
end
