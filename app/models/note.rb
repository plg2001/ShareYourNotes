class Note < ApplicationRecord
  MAX_RATING = 5
  validates :rating, numericality: { in: 0..MAX_RATING }


  
    before_save :set_default_uploaded_at

  def set_default_uploaded_at
    self.uploaded_at ||= Time.current
  end
    belongs_to :user
    has_many :note_tags, dependent: :delete_all
    has_many :tags, through: :note_tags
    has_many :note_topics, dependent: :delete_all
    has_many :topics, through: :note_topics
    belongs_to :faculty
    has_many :favourites, dependent: :delete_all
    has_many :favourited_by_users, through: :favourites, source: :user
    has_many :comments, dependent: :delete_all
    has_many :visualizzaziones,dependent: :delete_all
    has_many :create_ratings, dependent: :delete_all
    def increment_view_count
        self.views += 1
        self.save
    end


    def increment_download_count
      self.downloads += 1
      self.save
    end
end
