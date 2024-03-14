class UsersController < ApplicationController
  def create_client
    puts client_params

    if User.exists?(username: client_params[:username])
      render json: { success: false, message: 'User with given username already exist!', data: nil }, status: :conflict
      return
    end

    @client = User.new(client_params)
    if @client.save!
      render json: { success: true, message: 'Client created successfully', data: { client_id: @client.id } },
             status: :created
    else
      render json: { success: false, message: 'Unable to create client', data: nil }, status: :internal_server_error
    end
  end

  private

  def client_params
    params.require(:client).permit(:username, :password)
  end
end
