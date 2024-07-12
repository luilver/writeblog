class Blogs::BookmarksController < ApplicationController
  allow_unauthenticated_access

  include BlogScoped

  def show
    @leaf = @blog.leaves.active.find_by(id: last_read_leaf_id) if last_read_leaf_id.present?
  end

  private
    def last_read_leaf_id
      cookies["reading_progress_#{@blog.id}"]
    end
end
