class Note < ApplicationRecord
    has_and_belongs_to_many :tags
    has_and_belongs_to_many :topics
end