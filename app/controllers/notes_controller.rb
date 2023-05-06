class NotesController < ApplicationController
    before_action :authenticate_user!
end