module Validators
  module CarValidator
    extend ActiveSupport::Concern

    included do
      validate :validate_brand_model_compatibility
      validate :validate_tesla_fuel_type
    end

    private

    def validate_brand_model_compatibility
      return unless brand.present? && model.present?

      case brand
      when "TESLA"
        unless Car::TESLA_MODELS.include?(model)
          errors.add(:model, "Invalid model for Tesla brand.")
        end
      when "MERCEDES"
        unless Car::MERCEDES_MODELS.include?(model)
          errors.add(:model, "Invalid model for Mercedes brand.")
        end
      end
    end

    def validate_tesla_fuel_type
      return unless brand == "TESLA" && model.present? && fuel_type.present?

      if Car::TESLA_MODELS.include?(model)
        if fuel_type != "ELECTRIC"
          errors.add(:fuel_type, "Tesla vehicles must have Electric fuel type.")
        end
      end
    end
  end
end
