class Note < ApplicationRecord
    has_many :note_tags
    has_many :tags, through: :note_tags
    has_many :note_topics
    has_many :topics, through: :note_topics
end
