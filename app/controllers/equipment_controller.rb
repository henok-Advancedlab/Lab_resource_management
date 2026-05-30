class EquipmentController < ApplicationController
  before_action :set_equipment, only: %i[show update destroy]

  # GET /equipment — list all ordered by name, optional ?status= filter, includes category name
  def index
    scope = Equipment.includes(:category).order(:name)
    scope = scope.where(status: params[:status]) if params[:status].present?
    render json: scope.map { |equipment| equipment_json(equipment) }
  end

  # GET /equipment/:id — include category and all maintenance records (newest first)
  def show
    render json: equipment_detail_json(@equipment)
  end

  # POST /equipment — accept category_id; a missing category fails the belongs_to validation (422)
  def create
    equipment = Equipment.create!(equipment_params)
    render json: equipment_json(equipment), status: :created
  end

  # PATCH/PUT /equipment/:id
  def update
    @equipment.update!(equipment_params)
    render json: equipment_json(@equipment)
  end

  # DELETE /equipment/:id — cascades to maintenance records via dependent: :destroy
  def destroy
    @equipment.destroy
    head :no_content
  end

  private

  def set_equipment
    @equipment = Equipment.find(params[:id])
  end

  def equipment_params
    params.require(:equipment).permit(:name, :serial_number, :status, :category_id)
  end

  def equipment_json(equipment)
    equipment.as_json(only: %i[id name serial_number status category_id created_at updated_at])
             .merge(category_name: equipment.category&.name)
  end

  def equipment_detail_json(equipment)
    equipment_json(equipment).merge(
      category: equipment.category.as_json(only: %i[id name]),
      maintenance_records: equipment.maintenance_records.order(performed_at: :desc)
                                    .as_json(only: %i[id performed_at description created_at updated_at])
    )
  end
end
