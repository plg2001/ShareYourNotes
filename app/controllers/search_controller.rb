class SearchController < ApplicationController
  def results
    @query = params[:query]
    @results = search(@query)
  end

  private

  def search(query)
    Note.where("name LIKE ?", "%#{query}%")
  end
end