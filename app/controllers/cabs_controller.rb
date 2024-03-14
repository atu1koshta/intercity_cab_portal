class CabsController < ApplicationController
  def create
    @cab = cab_object

    if @cab.nil?
      render json: { success: false, message: 'Cab with given id already exists', data: nil }, status: :conflict
    else
      begin
        @cab.save!
        render json: { success: true, message: 'Cab created successfully', data: { cab_id: @cab.id } },
               status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { success: false, message: 'Something went wrong.', data: { errors: e.record.errors.full_messages.join(', ') } },
               status: :unprocessable_entity
      end
    end
  end

  private

  def cab_params
    params.require(:cab).permit(:id, :city_id, :state)
  end

  def cab_object
    id = cab_params[:id]
    return if id.present? && Cab.exists?(id:)

    Cab.new(cab_params)
  end
end
