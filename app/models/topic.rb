class Topic < ApplicationRecord
    has_many :note_topics,dependent: :destroy
end
