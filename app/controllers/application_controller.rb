class ApplicationController < ActionController::Base
    before_action :configure_permitted_parameters ,if: :devise_controller?
    rescue_from ActionController::InvalidAuthenticityToken, with: :handle_invalid_authenticity_token 
    def application
    end

    def access_denied(exception)
        redirect_to root_path,alert: exception.message
    end

    protected

    def configure_permitted_parameters
        devise_parameter_sanitizer.permit(:sign_up, keys: [:username,:name])
    end

    private

    def handle_invalid_authenticity_token
        flash[:alert] = "Sessione scaduta. Per favore, effettua di nuovo l'accesso."
        redirect_to new_user_session_path
    end

    

end
