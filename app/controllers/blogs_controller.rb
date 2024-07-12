class BlogsController < ApplicationController
  allow_unauthenticated_access only: %i[ index show ]

  before_action :ensure_index_is_not_empty, only: :index
  before_action :set_blog, only: %i[ show edit update destroy ]
  before_action :set_users, only: %i[ new edit ]
  before_action :ensure_editable, only: %i[ edit update destroy ]

  def index
    @blogs = Blog.accessable_or_published.ordered
  end

  def new
    @blog = Blog.new
  end

  def create
    blog = Blog.create! blog_params
    update_accesses(blog)

    redirect_to blog_slug_url(blog)
  end

  def show
    @leaves = @blog.leaves.active.with_leafables.positioned
  end

  def edit
  end

  def update
    @blog.update(blog_params)
    update_accesses(@blog)
    remove_cover if params[:remove_cover] == "true"

    redirect_to blog_slug_url(@blog)
  end

  def destroy
    @blog.destroy

    redirect_to root_url
  end

  private
    def set_blog
      @blog = Blog.accessable_or_published.find params[:id]
    end

    def set_users
      @users = User.active.ordered
    end

    def ensure_editable
      head :forbidden unless @blog.editable?
    end

    def ensure_index_is_not_empty
      if !signed_in? && Blog.published.none?
        require_authentication
      end
    end

    def blog_params
      params.require(:blog).permit(:title, :subtitle, :author, :cover, :remove_cover, :everyone_access, :theme)
    end

    def update_accesses(blog)
      editors = [ Current.user.id, *params[:editor_ids]&.map(&:to_i) ]
      readers = [ Current.user.id, *params[:reader_ids]&.map(&:to_i) ]

      blog.update_access(editors: editors, readers: readers)
    end

    def remove_cover
      @blog.cover.purge
    end
end
