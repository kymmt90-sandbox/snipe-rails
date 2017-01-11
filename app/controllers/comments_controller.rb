class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :update, :destroy]

  def index
    @comments = Comment.where(snippet_id: params[:snippet_id])
  end

  def show
  end

  def create
    @comment_author = User.find(params[:comment][:comment_author_id])
    @snippet = Snippet.find(params[:snippet_id])
    @comment = Comment.new(comment_params.merge(comment_author: @comment_author, snippet: @snippet))
    if @comment.save
      render status: :created
    end
  end

  def update
    if @comment.update_attributes(comment_params)
      render status: :ok
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
