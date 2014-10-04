class FeedsController < ApplicationController
  before_action :set_feed, only: [:show, :destroy, :refresh]

  # GET /feeds
  # GET /feeds.json
  def index
    @feed = Feed.new
    @feeds = Feed.alphabetical.all
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @entries = Entry.includes(:feed)
    .where(feed_id: params[:id])
    .recent
    .paginate(:page => params[:page], :per_page => 20)

    respond_to do |format|
      format.html { render :show }
      format.json { render :json => {
          :partial_html => render_to_string(partial: 'entries/list', formats: :html, locales: {:entries => @entries}),
          :last_entry_at => Entry.last_entry_at
        }
      }
    end
  end

  def new
    @feed = Feed.new
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.new(
        :url => feed_params[:url],
        :title => feed_params[:url]
    )

    if @feed.save
      @feed.update_from_remote
      respond_to do |format|
        format.html { redirect_to root_url, notice: 'Mmmm more feeds.' }
        format.json { render :show, status: :created, location: @feed }
      end
    else
      respond_to do |format|
        format.html { render :new }
        format.json { render json: @feed.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /feeds/1
  # DELETE /feeds/1.json
  def destroy
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Feed removed.' }
      format.json { head :no_content }
    end
  end

  def refresh
    notice = 'Feeds are updating.'

    if Delayed::Job.where("handler LIKE '%id: #{@feed.id}%'").count > 0
      Feed.fetch_all
      notice = 'Updating feeds.'
    end

    respond_to do |format|
      format.html { redirect_to feed_url(@feed.id), notice: notice }
      format.json { head :no_content }
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_feed
    @feed = Feed.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def feed_params
    params.require(:feed).permit(:url)
  end
end
