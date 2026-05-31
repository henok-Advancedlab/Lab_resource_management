class MaintenanceRecordsController < ApplicationController
  before_action :set_maintenance_record, only: %i[show update destroy]

  # GET /maintenance_records — list all, newest first, optional ?equipment_id= filter, includes equipment name
  def index
    records = MaintenanceRecord.includes(:equipment).order(performed_at: :desc)
    records = records.where(equipment_id: params[:equipment_id]) if params[:equipment_id].present?
    render json: records.map { |record| maintenance_record_json(record) }
  end

  # GET /maintenance_records/:id — show one with its equipment name
  def show
    render json: maintenance_record_json(@maintenance_record)
  end

  # POST /maintenance_records
  def create
    record = MaintenanceRecord.create!(maintenance_record_params)
    render json: maintenance_record_json(record), status: :created
  end

  # PATCH/PUT /maintenance_records/:id
  def update
    @maintenance_record.update!(maintenance_record_params)
    render json: maintenance_record_json(@maintenance_record)
  end

  # DELETE /maintenance_records/:id
  def destroy
    @maintenance_record.destroy
    head :no_content
  end

  private

  def set_maintenance_record
    @maintenance_record = MaintenanceRecord.includes(:equipment).find(params[:id])
  end

  def maintenance_record_params
    params.require(:maintenance_record).permit(:equipment_id, :performed_at, :description)
  end

  def maintenance_record_json(record)
    record.as_json(only: %i[id equipment_id performed_at description created_at updated_at]).merge(equipment_name: record.equipment&.name)
  end
end
