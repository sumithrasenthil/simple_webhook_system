class UsersController < ApplicationController
  before_action :find_user, only: [:update]

  def create
    if User.create(user_params)
      render json: { success: true, message: 'User created successfully' }
    else
      render json: { success: false, message: 'User not created', errors: @user.errors.full_messages.to_sentence }
    end
  end

  def update
    if @user.update(user_params)
      render json: { success: true, message: 'User updated successfully' }
    else
      render json: { success: false, message: 'User not updated', errors: @user.errors.full_messages.to_sentence }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone_number, :street_address, :city, :state, :zipcode, :role)
  end

  def find_user
    @user = User.find_by(id: params[:id])
    render json: { success: false, message: 'User not found' }, status: 404 && return if @user
  end
end
