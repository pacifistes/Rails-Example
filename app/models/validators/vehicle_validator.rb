module Validators
  module VehicleValidator
    extend ActiveSupport::Concern

    included do
      validate :validate_vehicle_type_brand_compatibility
    end

    private

    def validate_vehicle_type_brand_compatibility
      if vehicle_type == "CAR"
        if motorbike.present?
          errors.add(:base, "A car vehicle cannot have motorbike metadata.")
        end
        unless car.present?
          errors.add(:base, "A car vehicle must have car metadata.")
        end
      elsif vehicle_type == "MOTOR_BIKE"
        if car.present?
          errors.add(:base, "A motorbike vehicle cannot have car metadata.")
        end
        unless motorbike.present?
          errors.add(:base, "A motorbike vehicle must have motorbike metadata.")
        end
      end
    end
  end
end
