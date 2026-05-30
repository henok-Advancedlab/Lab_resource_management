class MaintenanceRecordsController < ApplicationController
  def index
  end

  def show
  end

  def create
  end

  def update
  end

  def destroy
  end

    private

  def set_maintenance_record
    @maintenance_record = MaintenanceRecord.includes(:equipment).find(params[:id])
  end

  def maintenance_record_params
    params.require(:maintenance_record).permit(:equipment_id, :performed_at, :description)
  end

  def maintenance_record_json(record)
    record.as_json(only: %i[id equipment_id performed_at description created_at updated_at]).merge(
      equipment_name: record.equipment&.name
    )
  end
end
