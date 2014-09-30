class FeedsController < ApplicationController
  # GET /feeds
  # GET /feeds.json
  def index
    @feed = Feed.new
    @feeds = Feed.all
  end

  # GET /feeds/1
  # GET /feeds/1.json
  def show
    @feed = Feed.find(params[:id])
    @entries = Entry.where(feed_id: params[:id])
      .recent
      .paginate(:page => params[:page])
  end

  # POST /feeds
  # POST /feeds.json
  def create
    @feed = Feed.create_from_url(feed_params[:url])

    respond_to do |format|
      if @feed.errors.blank?
        format.html { redirect_to root_url, notice: 'Feed was successfully created.' }
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
    @feed = Feed.find(params[:id])
    @feed.destroy
    respond_to do |format|
      format.html { redirect_to root_url, notice: 'Feed was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Never trust parameters from the scary internet, only allow the white list through.
    def feed_params
      params.require(:feed).permit(:url)
    end
end
