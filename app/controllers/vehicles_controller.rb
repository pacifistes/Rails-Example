class VehiclesController < ApplicationController
  before_action :set_vehicle, only: %i[ show edit update destroy ]
  before_action :authorize_create, only: %i[ new create ]
  before_action :authorize_edit, only: %i[ edit update ]

  # GET /vehicles or /vehicles.json
  def index
    @vehicles = Vehicle.all
  end

  # GET /vehicles/1 or /vehicles/1.json
  def show
  end

  # GET /vehicles/new
  def new
    @vehicle = Vehicle.new
  end

  # GET /vehicles/1/edit
  def edit
    if @vehicle.vehicle_type == "CAR"
      @vehicle.build_car unless @vehicle.car
    elsif @vehicle.vehicle_type == "MOTOR_BIKE"
      @vehicle.build_motorbike unless @vehicle.motorbike
    end
  end

  # POST /vehicles or /vehicles.json
  def create
    params_hash = vehicle_params

    # Remove nested attributes that don't match the vehicle type
    if params_hash[:vehicle_type] == "CAR"
      params_hash = params_hash.except(:motorbike_attributes)
    elsif params_hash[:vehicle_type] == "MOTOR_BIKE"
      params_hash = params_hash.except(:car_attributes)
    end

    @vehicle = Vehicle.new(params_hash)
    @vehicle.added_by = Current.user

    respond_to do |format|
      if @vehicle.save
        format.html { redirect_to @vehicle, notice: "Vehicle was successfully created." }
        format.json { render :show, status: :created, location: @vehicle }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /vehicles/1 or /vehicles/1.json
  def update
    # Remove vehicle_type from params since it shouldn't be changeable
    params_hash = vehicle_params.except(:vehicle_type)

    # Remove nested attributes that don't match the vehicle type
    if @vehicle.vehicle_type == "CAR"
      params_hash = params_hash.except(:motorbike_attributes)
    elsif @vehicle.vehicle_type == "MOTOR_BIKE"
      params_hash = params_hash.except(:car_attributes)
    end

    # Handle images separately to avoid replacing all images
    new_images = params_hash.delete(:images)

    # Store image IDs to remove (but don't purge yet - only if update succeeds)
    image_ids_to_remove = []
    if params[:vehicle] && params[:vehicle][:image_ids_to_remove].present?
      image_ids_to_remove = params[:vehicle][:image_ids_to_remove].reject(&:blank?)
    end

    respond_to do |format|
      if @vehicle.update(params_hash)
        # Only purge images after successful update
        image_ids_to_remove.each do |image_id|
          image = @vehicle.images.find_by(id: image_id)
          image&.purge
        end

        # Attach new images if any were uploaded
        if new_images.present?
          new_images.each do |image|
            @vehicle.images.attach(image) if image.present?
          end
        end

        format.html { redirect_to @vehicle, notice: "Vehicle was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @vehicle }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @vehicle.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vehicles/1 or /vehicles/1.json
  def destroy
    @vehicle.destroy!

    respond_to do |format|
      format.html { redirect_to vehicles_path, notice: "Vehicle was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_vehicle
      @vehicle = Vehicle.find(params.expect(:id))
    end

    # Authorization methods
    def authorize_create
      # Check general permission
      unless Current.user&.admin? || Current.user&.car_manager? || Current.user&.motor_bike_manager?
        redirect_to vehicles_path, alert: "You don't have permission to create vehicles."
        return
      end

      # For create action, also check vehicle type permission
      if action_name == "create"
        vehicle_type = params.dig(:vehicle, :vehicle_type)
        unless can_manage_vehicle_type?(vehicle_type)
          respond_to do |format|
            format.html { redirect_to vehicles_path, alert: "You don't have permission to create this type of vehicle." }
            format.json { render json: { error: "You don't have permission to create this type of vehicle." }, status: :forbidden }
          end
        end
      end
    end

    def authorize_edit
      # Check general permission
      unless Current.user&.admin? || Current.user&.car_manager? || Current.user&.motor_bike_manager?
        redirect_to vehicles_path, alert: "You don't have permission to edit vehicles."
        return
      end

      # Check vehicle type permission
      unless can_manage_vehicle_type?(@vehicle.vehicle_type)
        respond_to do |format|
          format.html { redirect_to @vehicle, alert: "You don't have permission to edit this type of vehicle." }
          format.json { render json: { error: "You don't have permission to edit this type of vehicle." }, status: :forbidden }
        end
      end
    end

    def can_manage_vehicle_type?(vehicle_type)
      return false unless Current.user

      case vehicle_type
      when "CAR"
        Current.user.admin? || Current.user.car_manager?
      when "MOTOR_BIKE"
        Current.user.admin? || Current.user.motor_bike_manager?
      else
        false
      end
    end

    # Only allow a list of trusted parameters through.
    def vehicle_params
      params.expect(vehicle: [ :vehicle_type, :description, :price_by_day, :year_of_production, images: [], car_attributes: [ :id, :brand, :model, :engine_cc, :fuel_type, :gearbox, :seats ], motorbike_attributes: [ :id, :brand, :model, :engine_cc, :has_sidecar ] ])
    end
end
