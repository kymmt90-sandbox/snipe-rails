class UsersController < ApplicationController
  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:update, :destroy]
  before_action :must_be_oneself, only: [:update, :destroy]

  def show
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render status: :created
    else
      render json: @user.errors, status: :bad_request
    end
  end

  def update
    if @user.update_attributes(user_params)
      render status: :ok
    else
      render json: @user.errors, status: :bad_request
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

  def must_be_oneself
    render json: {}, status: :unauthorized unless current_user == @user
  end
end
