class Leaf < ApplicationRecord
  include Editable, Positionable

  belongs_to :blog, touch: true
  delegated_type :leafable, types: Leafable::TYPES, dependent: :destroy
  positioned_within :blog, association: :leaves, filter: :active

  enum :status, %w[ active trashed ].index_by(&:itself), default: :active

  scope :with_leafables, -> { includes(:leafable) }

  before_save :generate_slug, if: -> { slug.blank? || title_changed? }

  def generate_slug
    base_slug = title.to_s.parameterize.presence || "-"
    candidate = base_slug
    counter = 2
    while blog.leaves.where(slug: candidate).where.not(id: id).exists?
      candidate = "#{base_slug}-#{counter}"
      counter += 1
    end
    self.slug = candidate
  end
end
