module NotesHelper
    def user_online_status1(user)
        if user.last_seen.present? && user.last_seen > 10.minutes.ago &&  user.last_seen != nil
          content_tag(:span, "", class: "online-indicator1 online")
        else
          content_tag(:span,"", class: "online-indicator1 offline")
        end
    end
end
