class EntriesController < ApplicationController
  before_action :set_feed
  before_action :set_entry, only: [:show ]

  # GET /entries
  # GET /entries.json
  def index
    redirect_to @feed
  end

  # GET /entries/1
  # GET /entries/1.json
  def show
  end

  private
    def set_feed
      @feed = Feed.find(params[:feed_id])
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_entry
      @entry = Entry.find(params[:id])
    end
end
