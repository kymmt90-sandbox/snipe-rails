class StarsController < ApplicationController
  before_action :set_user
  before_action :set_snippet
  before_action :authenticate_user

  def show
    if @user.starred_snippets.exists?(@snippet.id)
      head :no_content
    else
      head :not_found
    end
  end

  def create
    head :unauthorized and return unless current_user == @user

    @user.starred_snippets << @snippet unless @user.starred_snippets.exists?(@snippet.id)
    head :no_content
  end

  def destroy
    head :unauthorized and return unless current_user == @user

    @user.starred_snippets.destroy(@snippet)
    head :no_content
  end

  private

  def set_user
    @user = User.find(params[:user_id])
  end

  def set_snippet
    @snippet = Snippet.find(params[:snippet_id])
  end
end
