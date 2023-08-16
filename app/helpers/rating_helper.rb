module RatingHelper
    def star_rating_class(note, index)
      if index < note.rating
        "text-warning"
      else
        "text-muted"
      end
    end

    def star_rating_hover_class
      "star_hover"
    end

    def staruser_rating_class(user, index)
     average_rating = user.rating 
      if index < average_rating
        "text-warning"
      else
        "text-muted"
      end
    end

  end