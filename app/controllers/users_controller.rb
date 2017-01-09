class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render status: :created
    end
  end

  def update
    if @user.update_attributes(user_params)
      render status: :ok
    end
  end

  def destroy
    @user.destroy!
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
