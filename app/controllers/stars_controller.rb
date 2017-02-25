class StarsController < ApplicationController
  before_action :set_snippet
  before_action :authenticate_user

  def show
    if Star.find_by(starring_user: current_user, starred_snippet: @snippet.id).present?
      head :no_content
    else
      head :not_found
    end
  end

  def create
    current_user.starred_snippets << @snippet unless current_user.starred_snippets.exists?(@snippet.id)
    head :no_content
  end

  def destroy
    current_user.starred_snippets.destroy(@snippet)
    head :no_content
  end

  private

  def set_snippet
    @snippet = Snippet.find(params[:snippet_id])
  end
end
