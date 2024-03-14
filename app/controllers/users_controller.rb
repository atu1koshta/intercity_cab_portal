class UsersController < ApplicationController
  def create_client
    if User.exists?(username: client_params[:username])
      render json: { success: false, message: 'User with given username already exist!', data: nil }, status: :conflict
    else
      @client = User.new(client_params)
      begin
        @client.save!
        render json: { success: true, message: 'Client created successfully', data: { client_id: @client.id } },
               status: :created
      rescue ActiveRecord::RecordInvalid => e
        render json: { success: false, message: 'Unable to create client', data: { errors: e.record.errors.full_messages.join(', ') } },
               status: :internal_server_error
      end
    end
  end

  private

  def client_params
    params.require(:client).permit(:username, :password)
  end
end
