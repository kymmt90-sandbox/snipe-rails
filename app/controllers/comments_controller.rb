class CommentsController < ApplicationController
  include Swagger::CommentApiSchema

  before_action :set_comment, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]

  def index
    @snippet = Snippet.find(params[:snippet_id])
    @comments = Comment.where(snippet: @snippet)
  end

  def show
  end

  def create
    head :unauthorized and return unless current_user.id == comment_params[:comment_author_id].to_i

    @snippet = Snippet.find(params[:snippet_id])
    @comment = Comment.new(comment_params.merge(snippet: @snippet))
    if @comment.save
      render status: :created
    else
      render json: validation_errors(@comment), status: :bad_request
    end
  end

  def update
    head :unauthorized and return unless current_user == @comment.comment_author

    if @comment.update_attributes(comment_params)
      render status: :ok
    else
      render json: validation_errors(@comment), status: :bad_request
    end
  end

  def destroy
    head :unauthorized and return unless current_user == @comment.comment_author

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
