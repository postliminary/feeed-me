class HomeController < ApplicationController
  def index
    @feed = Feed.new
    @feeds = Feed.alphabetical.all
    @entries = Entry.includes(:feed)
      .recent
      .paginate(:page => params[:page])

    respond_to do |format|
      format.html { render :index }
      format.json { render :json => {
          :partial_html => render_to_string(partial: 'entries/list', formats: :html, locales: {:entries => @entries}),
          :last_updated => (Time.now.utc - Entry.maximum(:updated_at)).floor * 1000
        }
      }
    end
  end

  def refresh_feeds
    if Delayed::Job.count > 0
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'Feeds are updating.' }
        format.json { head :no_content }
      end
    else
      Feed.fetch_all
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'Updating feeds.' }
        format.json { head :no_content }
      end
    end
  end
end
