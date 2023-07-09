class Note < ApplicationRecord
  MAX_RATING = 5
  validates :rating, numericality: { in: 0..MAX_RATING }


  has_many :create_ratings, dependent: :destroy
  
    before_save :set_default_uploaded_at

  def set_default_uploaded_at
    self.uploaded_at ||= Time.current
  end
    belongs_to :user
    has_many :note_tags, dependent: :destroy
    has_many :tags, through: :note_tags
    has_many :note_topics, dependent: :destroy
    has_many :topics, through: :note_topics
    belongs_to :faculty
    has_many :favourites, dependent: :destroy
    has_many :favourited_by_users, through: :favourites, source: :user
    has_many :comments, dependent: :destroy
end
