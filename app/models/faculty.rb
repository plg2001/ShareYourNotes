class Faculty < ApplicationRecord
    has_many :notes,dependent: :nullify
    validates :name, presence: true
end
