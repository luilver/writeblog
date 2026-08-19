module SetBlogLeaf
  extend ActiveSupport::Concern

  included do
    before_action :set_blog
    before_action :set_leaf, :set_leafable, only: %i[ show edit update destroy ]
  end

  private
    def set_blog
      if params[:blog_slug]
        @blog = Blog.accessable_or_published.find_by!(slug: params[:blog_slug])
      else
        @blog = Blog.accessable_or_published.find(params[:blog_id])
      end
    end

    def set_leaf
      if params[:leafable_slug]
        @leaf = @blog.leaves.active.find_by!(slug: params[:leafable_slug])
      else
        @leaf = @blog.leaves.active.find(params[:id])
      end
    end

    def set_leafable
      instance_variable_set "@#{instance_name}", @leaf.leafable
    end

    def ensure_editable
      head :forbidden unless @blog.editable?
    end

    def model_class
      controller_leafable_name.constantize
    end

    def instance_name
      controller_leafable_name.underscore
    end

    def controller_leafable_name
      self.class.to_s.remove("Controller").demodulize.singularize
    end
end
