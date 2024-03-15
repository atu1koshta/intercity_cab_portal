class CabsController < ApplicationController
  def create
    cab = cab_object

    if cab.nil?
      render json: { success: false, message: 'Cab with given id already exists', data: nil }, status: :conflict
    else
      begin
        ActiveRecord::Base.transaction do
          cab.save!
          cab.cab_histories.create!(state: cab.state)
        end
        render json: { success: true, message: 'Cab created successfully', data: { cab_id: cab.id } },
               status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { success: false, message: 'Something went wrong.', data: { errors: e.record.errors.full_messages.join(', ') } },
               status: :unprocessable_entity
      end
    end
  end

  def update
    cab = Cab.find_by(id: params[:id])

    if cab.nil?
      render json: { success: false, message: 'Invalid cab id provided', data: nil }, status: :not_found
    else
      response = update_helper(cab)
      render response
    end
  end

  private

  def cab_params
    params.require(:cab).permit(:id, :city_id, :state)
  end

  def update_cab_params
    params.require(:cab).permit(:city_id, :state)
  end

  def cab_object
    id = cab_params[:id]
    return if id.present? && Cab.exists?(id:)

    Cab.new(cab_params)
  end

  def update_helper(cab)
    if update_cab_params.key?(:state) && update_cab_params.key?(:city_id)
      if cab.state == update_cab_params[:state] && cab.city_id == update_cab_params[:city_id]
        handle_total_idle_time_update(cab)
        { json: { success: false, message: 'Cab already in given state and city!', data: nil }, status: :ok }
      else
        handle_update(cab)
      end
    elsif update_cab_params.key?(:city_id)
      if cab.city_id == update_cab_params[:city_id]
        handle_total_idle_time_update(cab)
        { json: { success: false, message: 'Cab already in given city!', data: nil }, status: :ok }
      else
        handle_update(cab, only_city_update: true)
      end
    elsif update_cab_params.key?(:state)
      if cab.state == update_cab_params[:state]
        handle_total_idle_time_update(cab)
        { json: { success: false, message: 'Cab already in given state!', data: nil }, status: :ok }
      else
        handle_update(cab)
      end
    end
  end

  def handle_update(cab, only_city_update: false)
    now = Time.now
    last_cab_history = cab.cab_histories.last
    idle_time = last_cab_history.state == 'IDLE' ? now - last_cab_history.start_time : 0

    new_params = update_cab_params[:state] == 'ON_TRIP' && !update_cab_params.key?(:city_id) ? update_cab_params.merge({ city_id: nil }) : update_cab_params

    begin
      ActiveRecord::Base.transaction do
        cab.update!(new_params.merge({ total_idle_time: cab.total_idle_time + idle_time }))

        unless only_city_update
          last_cab_history.update!(end_time: now)
          cab.cab_histories.create!(state: new_params[:state], start_time: now)
        end
      end
      { json: { success: true, message: 'Cab updated successfully', data: nil }, status: :ok }
    rescue ActiveRecord::RecordInvalid => e
      { json: { success: false, message: 'Something went wrong.', data: { errors: e.record.errors.full_messages.join(', ') } },
        status: :unprocessable_entity }
    rescue ActiveRecord::InvalidForeignKey => e
      { json: { success: false, message: 'Foreign key constraint violation.', data: { errors: e.message } },
        status: :unprocessable_entity }
    end
  end

  def handle_total_idle_time_update(cab)
    now = Time.now
    idle_time = cab.state == 'IDLE' ? now - cab.last_idle_start_time : 0

    return unless idle_time

    cab.update(total_idle_time: cab.total_idle_time + idle_time)
  end
end
