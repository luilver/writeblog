class Blogs::PublicationsController < ApplicationController
  include BlogScoped

  before_action :ensure_editable, only: %i[ edit update ]

  def show
  end

  def edit
  end

  def update
    @blog.update! blog_params
    redirect_to blog_slug_url(@blog)
  end

  private
    def blog_params
      params.require(:blog).permit(:published, :slug)
    end
end
