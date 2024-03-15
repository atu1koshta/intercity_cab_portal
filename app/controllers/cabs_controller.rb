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
      response = update_helper(cab, update_cab_params)
      render response
    end
  end

  def book
    city_id = book_params[:city_id]

    if city_id.nil? || City.find_by(id: city_id).nil?
      render json: { success: false, message: 'City not registered. Cab service unavailable in given city', data: nil },
             status: :not_found
    else
      cab = Cab.available_cab(city_id)

      if cab.nil?
        render json: { success: false, message: 'No cabs available at the moment. Please try later.', data: nil },
               success: :ok
      else
        update_params = { state: 'ON_TRIP' }
        response = handle_update(cab, update_params, booking_source_id: city_id)

        if response[:json][:success]
          render json: { success: true, message: 'Cab booked successfully', data: { cab_id: cab.id } }, status: :ok
        else
          render json: { success: false, message: 'Something went wrong while booking cab. Please try again.', data: nil },
                 status: :internal_server_error
        end
      end
    end
  end

  private

  def cab_params
    params.require(:cab).permit(:id, :city_id, :state)
  end

  def update_cab_params
    params.require(:cab).permit(:city_id, :state)
  end

  def book_params
    params.permit(:city_id)
  end

  def cab_object
    id = cab_params[:id]
    return if id.present? && Cab.exists?(id:)

    Cab.new(cab_params)
  end

  def update_helper(cab, update_params)
    if update_params.key?(:state) && update_params.key?(:city_id)
      if cab.state == update_params[:state] && cab.city_id == update_params[:city_id]
        { json: { success: false, message: 'Cab already in given state and city!', data: nil }, status: :ok }
      else
        handle_update(cab, update_params)
      end
    elsif update_params.key?(:city_id)
      if cab.city_id == update_params[:city_id]
        { json: { success: false, message: 'Cab already in given city!', data: nil }, status: :ok }
      else
        handle_update(cab, update_params, only_city_update: true)
      end
    elsif update_params.key?(:state)
      if cab.state == update_params[:state]
        { json: { success: false, message: 'Cab already in given state!', data: nil }, status: :ok }
      else
        handle_update(cab, update_params)
      end
    end
  end

  def handle_update(cab, update_params, booking_source_id: nil, only_city_update: false)
    now = Time.now
    last_cab_history = cab.cab_histories.last

    update_params.merge!({ city_id: nil }) if update_params[:state] == 'ON_TRIP' && !update_params.key?(:city_id)

    begin
      ActiveRecord::Base.transaction do
        cab.update!(update_params)

        unless only_city_update
          last_cab_history.update!(end_time: now)
          cab.cab_histories.create!(cab_history_params(update_cab_params, now, booking_source_id))
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

  def cab_history_params(update_params, now, booking_source_id)
    cab_history_params = { state: update_params[:state], start_time: now }
    cab_history_params.merge!({ booking_source_id:, state: 'ON_TRIP' }) if booking_source_id.present?

    cab_history_params
  end
end
