class StarsController < ApplicationController
  before_action :set_user
  before_action :set_snippet

  def show
    if @user.starred_snippets.exists?(@snippet.id)
      head :no_content
    else
      head :not_found
    end
  end

  def create
    unless @user.starred_snippets.exists?(@snippet.id)
      @user.starred_snippets << @snippet
    end

    head :no_content
  end

  def destroy
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
