class HomeController < ApplicationController
  def index
    @feed = Feed.new
    @feeds = Feed.all
    @entries = Entry.recent.paginate(:page => params[:page])
  end

  private
end
