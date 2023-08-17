class TagsController < ApplicationController
    def search
        @search_query = params[:tag]
        @search_result = Tag.where('name LIKE ?', "%#{@search_query}%")
        
       
        respond_to do |format|
          format.html
          format.json { render json: @search_result }
        end
    end
end