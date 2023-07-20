# app/helpers/application_helper.rb
module ApplicationHelper
    def user_online_status(user)
      if user.last_seen.present? && user.last_seen > 10.minutes.ago &&  user.last_seen != nil
        content_tag(:span, "", class: "online-indicator online")
      else
        content_tag(:span,"", class: "online-indicator offline")
      end
    end
  end
  