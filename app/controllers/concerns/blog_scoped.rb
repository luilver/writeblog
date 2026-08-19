module BlogScoped extend ActiveSupport::Concern
  included do
    before_action :set_blog
  end

  private
    def set_blog
      if params[:blog_slug]
        @blog = Blog.accessable_or_published.find_by!(slug: params[:blog_slug])
      else
        @blog = Blog.accessable_or_published.find(params[:blog_id])
      end
    end

    def ensure_editable
      head :forbidden unless @blog.editable?
    end
end
