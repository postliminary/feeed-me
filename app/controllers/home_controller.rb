class HomeController < ApplicationController
  def index
    @feed = Feed.new
    @feeds = Feed.alphabetical.all
    @entries = Entry.includes(:feed)
      .recent
      .paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html { render :index }
      format.json { render :json => {
          :entries_partial_html => render_to_string(partial: 'entries/list', formats: :html, locales: {:entries => @entries}),
          :feeds_partial_html => render_to_string(partial: 'feeds/list', formats: :html, locales: {:feeds => @feeds}),
          :last_entry_at => Entry.last_entry_at
        }
      }
    end
  end

  def refresh_feeds
    notice = 'Feeds are updating.'

    if Delayed::Job.count == 0
      Feed.all.each { |feed| feed.update_from_remote }
      notice = 'Updating feeds.'
    end

    respond_to do |format|
      format.html { redirect_to root_url, notice: notice }
      format.json { head :no_content }
      end
  end
end
