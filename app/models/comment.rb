class Comment < ApplicationRecord
  belongs_to :note
  belongs_to :user


  def short_content
    content.truncate(100)
  end


end
