class HomeController < ApplicationController
  def index
    @feed = Feed.new
    @feeds = Feed.all
    @entries = Entry.recent.paginate(:page => params[:page])
  end

  def refresh_feeds
    Feed.fetch_all
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Refreshing feeds.' }
      format.json { head :no_content }
    end
  end
end
