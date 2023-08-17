class TopicsController < ApplicationController
  def search
      @search_query = params[:topic]
      @search_result = Topic.where('name LIKE ?', "%#{@search_query}%")
    
      respond_to do |format|
        format.html
        format.json { render json: @search_result }
      end
  end
end