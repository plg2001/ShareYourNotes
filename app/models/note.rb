class Note < ApplicationRecord
    before_save :set_default_uploaded_at

  def set_default_uploaded_at
    self.uploaded_at ||= Time.current
  end
    belongs_to :user
    has_many :note_tags
    has_many :tags, through: :note_tags
    has_many :note_topics
    has_many :topics, through: :note_topics
    
end
