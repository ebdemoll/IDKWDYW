class RecommendationsController < ApplicationController
  def index
    @recommendations = []
    @recommendations << Recommendation.find_by(usergroup_id: session[:ugid])
    respond_to do |format|
      format.html
      format.json { render json: @recommendations}
    end
  end

  def new
    @recommendation = Recommendation.new
  end

  def create
    @usergroup = Usergroup.find(session[:ugid])
    who_decides?
    yelp_call
    @recommendation = Recommendation.create(usergroup_id: @usergroup.id, name: @name, phone: @phone, address: @address, yelp_rating: @yelp_rating)
    redirect_to usergroup_path(@usergroup)
  end

  private

  def who_decides?
    if @usergroup.chooser.nil?
      @chooser = @usergroup.users.first
    else
      @usergroup.users.each do |user|
        if user.id != @usergroup.chooser
          @chooser = user
        end
      end
      @usergroup.update_attribute(:chooser, @chooser.id)
    end
  end

  def yelp_call
    params = {
      term: @chooser.preferences[0].find,
      category_filter: ('restaurants'),
      limit: 1
    }
    @yelp_data = Yelp.client.search(@chooser.preferences[0].location, params)
    @yelp_data.businesses.each do |result|
      @name = result.name
      @phone = result.display_phone
      @address = result.location.display_address[0]
      @yelp_rating = result.rating
    end
  end

end
