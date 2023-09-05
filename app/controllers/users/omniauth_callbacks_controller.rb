class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
    rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_authenticity_token 
    def facebook
        @user = User.from_omniauth(request.env["omniauth.auth"])
        if @user.persisted?
            sign_in_and_redirect @user, :event => :authentication 
            set_flash_message(:notice, :success, :kind => "Facebook") if
            is_navigational_format?
        else
            session["devise.facebook_data"] = request.env["omniauth.auth"]
            redirect_to new_user_registration_url
        end
    end
    
    def google_oauth2
        @user = User.from_omniauth(request.env['omniauth.auth'])
        if @user.persisted? 
            flash[:notice] = I18n.t 'devise.omniauth_callbacks.success', kind: 'Google'
            sign_in_and_redirect @user, event: :authentication
        else
          session['devise.google_data'] = request.env['omniauth.auth'].except('extra')
          redirect_to new_user_registration_url, alert: @user.errors.full_messages.join("\n")
        end
    end

    def failure
        redirect_to root_path
    end

    private

    def handle_invalid_authenticity_token
        flash[:alert] = "Sessione scaduta. Per favore, effettua di nuovo l'accesso."
        redirect_to new_user_session_path
    end

end