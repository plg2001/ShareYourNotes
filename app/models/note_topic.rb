class NoteTopic < ApplicationRecord
  belongs_to :note
  belongs_to :topic
end