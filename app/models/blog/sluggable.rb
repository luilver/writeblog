module Blog::Sluggable
  extend ActiveSupport::Concern

  included do
    before_save :generate_slug, if: -> { slug.blank? || title_changed? }
  end

  def generate_slug
    base_slug = title.to_s.parameterize.presence || "-"
    candidate = base_slug
    counter = 2
    while Blog.where(slug: candidate).where.not(id: id).exists?
      candidate = "#{base_slug}-#{counter}"
      counter += 1
    end
    self.slug = candidate
  end
end
