class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]

  def index
    @snippet = Snippet.find(params[:snippet_id])
    @comments = Comment.where(snippet: @snippet)
  end

  def show
  end

  def create
    @snippet = Snippet.find(params[:snippet_id])
    @comment = Comment.new(comment_params.merge(snippet: @snippet))
    if @comment.save
      render status: :created
    else
      render json: @comment.errors, status: :bad_request
    end
  end

  def update
    if @comment.update_attributes(comment_params)
      render status: :ok
    else
      render json: @comment.errors, status: :bad_request
    end
  end

  def destroy
    @comment.destroy!
    head :no_content
  end

  private

  def set_comment
    @comment = Comment.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content, :comment_author_id)
  end
end
