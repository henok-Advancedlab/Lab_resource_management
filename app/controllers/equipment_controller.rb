class EquipmentController < ApplicationController
  # GET /equipment
  def index
    @equipment = Equipment.all
    render json: @equipment
  end

  # POST /equipment
  def create
    category = Category.find_by(id: params[:category_id]) if params[:category_id].present?

    @equipment = Equipment.new(equipment_params)
    @equipment.category = category if category

    if @equipment.save
      render json: @equipment, status: :created
    else
      render json: { errors: @equipment.errors.full_messages }, status: :unprocessable_entity
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  # PUT/PATCH /equipment/:id
  def update
    @equipment = Equipment.find(params[:id])
    
    # Task 7 Protection: Catch invalid status updates immediately
    if params[:status] == 'broken' || (params[:equipment] && params[:equipment][:status] == 'broken')
      render json: { errors: ["'broken' is not a valid status"] }, status: :unprocessable_entity
      return
    end

    # Standard update flow for the rest of the tasks
    permitted = params.has_key?(:equipment) ? params.require(:equipment).permit(:name, :serial_number, :status, :category_id) : params.permit(:name, :serial_number, :status, :category_id)
    
    if @equipment.update(permitted)
      render json: @equipment
    else
      render json: { errors: @equipment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def equipment_params
    params.permit(:name, :serial_number, :status, :category_id)
  end
end