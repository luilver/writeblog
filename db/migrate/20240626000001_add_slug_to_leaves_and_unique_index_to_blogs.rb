class AddSlugToLeavesAndUniqueIndexToBlogs < ActiveRecord::Migration[8.0]
  def up
    add_column :leaves, :slug, :string

    Leaf.reset_column_information
    Leaf.find_each do |leaf|
      base_slug = leaf.title.to_s.parameterize.presence || "-"
      slug = base_slug
      counter = 2
      while Leaf.where(blog_id: leaf.blog_id, slug: slug).where.not(id: leaf.id).exists?
        slug = "#{base_slug}-#{counter}"
        counter += 1
      end
      leaf.update_column(:slug, slug)
    end

    change_column :leaves, :slug, :string, null: false
    add_index :leaves, [:blog_id, :slug], unique: true
    add_index :blogs, :slug, unique: true
  end

  def down
    remove_index :blogs, :slug
    remove_index :leaves, [:blog_id, :slug]
    remove_column :leaves, :slug
  end
end
