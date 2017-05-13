class SnippetsController < ApplicationController
  include Swagger::SnippetApiSchema

  before_action :set_snippet, only: [:show, :update, :destroy]
  before_action :authenticate_user, only: [:create, :update, :destroy]

  INDEX_MAX_SNIPPETS = 3000

  def index
    relation = Snippet.includes(:author)
    if params[:user_id]
      author = User.find(params[:user_id])
      relation = relation.where(author_id: author.id)
      response.headers['Link'] = link_header(url_for(:user_snippets), author.id)
    else
      response.headers['Link'] = link_header(url_for(:snippets))
    end

    @snippets = relation.limit(INDEX_MAX_SNIPPETS).page(params[:page])
  end

  def show
  end

  def create
    head :unauthorized and return unless @author = current_user

    @snippet = Snippet.new(snippet_params.merge(author: @author))
    if @snippet.save
      render status: :created
    else
      render json: validation_errors(@snippet), status: :bad_request
    end
  end

  def update
    head :unauthorized and return unless current_user == @snippet.author

    if @snippet.update_attributes(snippet_params)
      render status: :ok
    else
      render json: validation_errors(@snippet), status: :bad_request
    end
  end

  def destroy
    head :unauthorized and return unless current_user == @snippet.author

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

  def link_header(url, author_id = nil)
    @current_page = Snippet.page(params[:page]).current_page
    @page_out_of_range = Snippet.page_out_of_range?(params[:page], author_id)
    @total_pages = Snippet.total_pages(author_id)

    [first_link(url), previous_link(url), next_link(url), last_link(url)].compact.join(', ')
  end

  def first_link(url)
    %(<#{url}?page=1>; rel="first")
  end

  def previous_link(url)
    return if @page_out_of_range || @current_page <= 1
    %(<#{url}?page=#{@current_page - 1}>; rel="previous")
  end

  def next_link(url)
    return if @page_out_of_range || @current_page >= @total_pages
    %(<#{url}?page=#{@current_page + 1}>; rel="next")
  end

  def last_link(url)
    %(<#{url}?page=#{@total_pages}>; rel="last")
  end
end
