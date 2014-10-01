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
      .paginate(:page => params[:page])
  end

  def new
    @feed = Feed.new
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.create_from_url(feed_params[:url])

    respond_to do |format|
      if @feed.errors.blank?
        format.html { redirect_to root_url, notice: 'Mmmm more feeds.' }
        format.json { render :show, status: :created, location: @feed }
      else
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
    if Delayed::Job.where("handler LIKE '%id: #{@feed.id}%'").count > 0
      respond_to do |format|
        format.html { redirect_to feed_url(@feed.id), notice: 'Feed is updating.' }
        format.json { head :no_content }
      end
    else
      @feed.fetch
      respond_to do |format|
        format.html { redirect_to feed_url(@feed.id), notice: 'Updating feed.' }
        format.json { head :no_content }
      end
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
