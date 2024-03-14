class CitiesController < ApplicationController
  def create
    if city_params[:city].present?
      city_attr = city_params[:city]
      id = city_attr[:id]
      name = city_attr[:name]

      if id.present?
        if City.exists?(id:)
          render json: { success: false, message: 'City with given id already exists', data: nil }, status: :ok
        else
          @city = City.new(id:, name:)
        end
      else
        @city = City.new(name:)
      end
    else
      @city = City.new
    end

    return unless @city

    begin
      @city.save!
      render json: { success: true, message: 'City created successfully', data: { city_id: @city.id } },
             status: :created
    rescue ActiveRecord::RecordInvalid => e
      render json: { success: false, message: 'Something went wrong.', data: { errors: e.record.errors.full_messages.join(', ') } },
             status: :unprocessable_entity
    end
  end

  private

  def city_params
    params.permit(city: %i[id name])
  end
end
