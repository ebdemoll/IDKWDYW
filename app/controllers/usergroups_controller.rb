# frozen_string_literal: true
class UsergroupsController < ApplicationController
    def index
      @memberships = Membership.where(user_id: current_user.id)
      unless @memberships.nil?
        @usergroups = []
        @memberships.each do |membership|
          @usergroups << Usergroup.find(membership.usergroup_id)
        end
      end
    end

    def show
      @preference = Preference.new
      @usergroup = Usergroup.find(params[:id])
      session[:ugid] = @usergroup.id
      @recommendation = Recommendation.find_by(usergroup_id: @usergroup.id)
      need_preference_form?
      belongs_to_group?(@usergroup.id)
    end

    def new
      @usergroup = Usergroup.new
    end

    def create
      @usergroup = Usergroup.new(usergroup_params)
      if @usergroup.save
        session[:ugid] = @usergroup.id
        redirect_to '/memberships/create'
        flash[:notice] = "Group added successfully"
      else
        flash[:notice] = @usergroup.errors.full_messages.join(", ")
        render :new
      end
    end

    def edit
      @usergroup = Usergroup.find(params[:id])
      session[:ugid] = @usergroup.id
      @invite = Invite.new
    end

   private

   def usergroup_params
     params.require(:usergroup).permit(:name, :user)
   end

   def need_preference_form?
     userpreference = Preference.find_by(user_id: current_user.id)
     if userpreference.nil?
       @ready = false
     else
       @ready = true
     end
   end

   def belongs_to_group?(usergroup_id)
     @membership = Membership.find_by(user_id: current_user.id, usergroup_id: usergroup_id)
     if @membership.nil?
       redirect_to usergroups_path
       flash[:notice] = "You Do Not Belong to That Group"
     end
   end
end
