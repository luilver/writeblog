module BlogScoped extend ActiveSupport::Concern
  included do
    before_action :set_blog
  end

  private
    def set_blog
      @blog = Blog.accessable_or_published.find(params[:blog_id])
    end

    def ensure_editable
      head :forbidden unless @blog.editable?
    end
end
