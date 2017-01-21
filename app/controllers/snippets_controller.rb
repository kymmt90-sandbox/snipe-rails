class SnippetsController < ApplicationController
  before_action :set_snippet, only: [:show, :update, :destroy]

  INDEX_MAX_SNIPPETS = 3000

  def index
    if params[:user_id].present?
      @author = User.find(params[:user_id])
      @snippets = Snippet.where(author: @author)
    else
      @snippets = Snippet.limit(INDEX_MAX_SNIPPETS)
    end
  end

  def show
  end

  def create
    @author  = User.find(params[:user_id])
    @snippet = Snippet.new(snippet_params.merge(author: @author))
    if @snippet.save
      render status: :created
    else
      render json: @snippet.errors, status: :bad_request
    end
  end

  def update
    if @snippet.update_attributes(snippet_params)
      render status: :ok
    else
      render json: @snippet.errors, status: :bad_request
    end
  end

  def destroy
    @snippet.destroy!
    head :no_content
  end

  private

  def set_snippet
    @snippet = Snippet.find(params[:id])
  end

  def snippet_params
    params.require(:snippet).permit(:title, :content)
  end
end
