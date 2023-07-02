module RatingHelper
    def star_rating_class(note, index)
      if index < note.rating
        "text-warning"
      else
        "text-muted"
      end
    end

    def star_rating_hover_class
      "text-primary"
    end

  end