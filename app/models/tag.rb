class Tag < ApplicationRecord
    has_many :note_tags,dependent: :destroy
end
