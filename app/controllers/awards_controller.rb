class AwardsController < ApplicationController
  # GET /awards
  # GET /awards.xml
  def index
    @awards = @organization.awards.all
  end

  # GET /awards/1
  # GET /awards/1.xml
  def show
    @award = Award.find(params[:id])
  end
end
