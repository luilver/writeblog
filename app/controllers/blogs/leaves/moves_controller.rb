class Blogs::Leaves::MovesController < ApplicationController
  include BlogScoped

  before_action :ensure_editable

  def create
    leaf, *followed_by = leaves
    leaf.move_to_position(position, followed_by: followed_by)
  end

  private
    def position
      params[:position].to_i
    end

    def leaves
      @blog.leaves.find(Array(params[:id]))
    end
end
