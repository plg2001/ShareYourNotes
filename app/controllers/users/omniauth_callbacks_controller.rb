class OmniauthCallbacksController < ApplicationController
    def facebook
        puts "OmniAuth callback hash: #{auth}"
        redirect_to root_path, notice: "Successfully connected with facebook #{auth.info.name}"
    end

    def auth
        request.env['omniauth.auth']
    end
end