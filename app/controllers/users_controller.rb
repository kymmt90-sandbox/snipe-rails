class UsersController < ApplicationController
  include Swagger::UserApiSchema

  before_action :set_user, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:update, :destroy]

  def show
    if @user.blank?
      authenticate_user
      if @user = current_user
        render status: :ok
      else
        head :unauthorized
      end
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      render status: :created
    else
      render json: validation_errors(@user), status: :bad_request
    end
  end

  def update
    head :unauthorized and return unless current_user == @user

    if @user.update_attributes(user_params)
      render status: :ok
    else
      render json: validation_errors(@user), status: :bad_request
    end
  end

  def destroy
    head :unauthorized and return unless current_user == @user

    @user.destroy!
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:id]) if params[:id].present?
  end

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
