class User < ApplicationRecord
  include Role, Transferable

  has_many :sessions, dependent: :destroy
  has_secure_password validations: false

  has_many :accesses, dependent: :destroy
  has_many :blogs, through: :accesses
  has_many :leaves, through: :blogs

  after_create :grant_access_to_everyone_blogs

  scope :active, -> { where(active: true) }
  scope :ordered, -> { order(:name) }

  def current?
    self == Current.user
  end

  def deactivate
    transaction do
      sessions.delete_all
      update! active: false, email_address: deactived_email_address
    end
  end

  private
    def deactived_email_address
      email_address&.gsub(/@/, "-deactivated-#{SecureRandom.uuid}@")
    end

    def grant_access_to_everyone_blogs
      all_accesses = Blog.with_everyone_access.ids.collect { |id| { blog_id: id, level: :reader } }
      accesses.insert_all(all_accesses)
    end
end
