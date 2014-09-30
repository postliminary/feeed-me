class HomeController < ApplicationController
  def index
    @entries = Entry.recent
  end
end
