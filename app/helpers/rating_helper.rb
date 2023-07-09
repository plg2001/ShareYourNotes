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

    def staruser_rating_class(user, index)
      sum_ratings = 0
      i = 0
      user.notes.each do |note|
        sum_ratings += note.rating
        i += 1
      end
      if i == 0
        i = 1
      end
      average_rating = sum_ratings / i
      if index <= average_rating
        "text-warning"
      else
        "text-muted"
      end
    end

  end