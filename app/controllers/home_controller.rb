class HomeController < ApplicationController
  def index
    @feed = Feed.new
    @feeds = Feed.all
    @entries = Entry.recent.paginate(:page => params[:page])
  end

  def refresh_feeds
    if Delayed::Job.count > 0
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'Feeds already being refreshed.' }
        format.json { head :no_content }
      end
    else
      Feed.fetch_all
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'Refreshing feeds.' }
        format.json { head :no_content }
      end
    end
  end
end
