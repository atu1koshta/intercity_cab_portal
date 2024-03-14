class CitiesController < ApplicationController
  def create
    @city = city_object

    if @city.nil?
      render json: { success: false, message: 'City with given id already exists', data: nil }, status: :ok
    else
      begin
        @city.save!
        render json: { success: true, message: 'City created successfully', data: { city_id: @city.id } },
               status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { success: false, message: 'Something went wrong.', data: { errors: e.record.errors.full_messages.join(', ') } },
               status: :unprocessable_entity
      end
    end
  end

  private

  def city_params
    params.permit(city: %i[id name])
  end

  def city_object
    city_attr = city_params[:city]

    if city_attr.present?
      id = city_attr[:id]
      name = city_attr[:name]

      if id.present?
        return if City.exists?(id:)

        city = City.new(id:, name:)
      else
        city = City.new(name:)
      end
    else
      city = City.new
    end

    city
  end
end
