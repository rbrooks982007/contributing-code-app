class HomeController < ApplicationController
 
  # Landing page
  # Gather all info if user is logged in
  # Lists teams
  def index
    # Get all teams
    @teams = Team.find(:all, :order => "name")
    # Get all users
    @users = User.find(:all, :order => "name")
    # users indexed by id 
    @members = @users.index_by(&:id)
    if current_user
      # Check to determine if the current_ user already is in a team ?
      @is_member = current_user ? current_user.team_member : nil
      if !@is_member
        #Collect add requests to user from other teams
        add_reqs = current_user ? current_user.add_requests : []
        # collect teams with members=4
        full_teams = Team.where(:member_count=>4).collect(&:id)
        # initialize
        @add_reqs = []
        # filter full teams
        add_reqs.each do |req|
          if !full_teams.include?(req.team_id)
            @add_reqs.push(req)
          end
        end
        # teams indexed by id 
        @teams_index = @teams.index_by(&:id)
        # collect requests to join if any
        @requested_teams = current_user ? current_user.join_requests.collect(&:team_id) : []
      else
        # Find the current user's team
        @my_team = current_user.team
        # Find team emmbers 
        @team_members = @my_team.team_members
        # owner user info
        @owner = @members[@my_team.owner_id]
        # To show team join requests to owner alone 
        if @my_team.owner_id == current_user.id
          # Collect add requests made by the owner
          @added_members = @my_team.add_requests.collect(&:user_id)
          @requests = @my_team.join_requests
          @candidates = @users.select{|user| user.team.blank? && !@added_members.include?(user.id)}
          # for type ahead durigna add 
          @handles = @candidates.collect(&:handle)
          @handles = @handles.to_s
        end
      end
    end
  end

  # faq
  def faq
    render :layout => "secondary_layout"
  end 

  def info 
    render :layout => "secondary_layout"
  end 

  # Admin pannel 
  # Only for admin
  def admin
    admins = [2,45]
    redirect_to "/" and return if current_user.nil? or !admins.include?(current_user.id)
    registered_ids = TeamMember.all.collect(&:user_id)
    users = User.where(:id=>registered_ids).order(:name)
    @members = TeamMember.all
    @teams = Team.find(:all, :order => "name")
    @ms = users.select{|u| u.gender == "M" && u.tee =="S"}.count 
    @mm = users.select{|u| u.gender == "M" && u.tee =="M"}.count 
    @ml = users.select{|u| u.gender == "M" && u.tee =="L"}.count 
    @mxl = users.select{|u| u.gender == "M" && u.tee =="XL"}.count 
    @mxxl = users.select{|u| u.gender == "M" && u.tee =="XXL"}.count 
    @fs = users.select{|u| u.gender == "F" && u.tee =="S"}.count 
    @fm = users.select{|u| u.gender == "F" && u.tee =="M"}.count 
    @fl = users.select{|u| u.gender == "F" && u.tee =="L"}.count 
    @fxl = users.select{|u| u.gender == "F" && u.tee =="XL"}.count 
    @fxxl = users.select{|u| u.gender == "F" && u.tee =="XXL"}.count 
    @intern_shuttle = users.select{|u| u.transport == 0}.count
    @caltrain_shuttle = users.select{|u| u.transport == 1}.count
    @no_shuttle = users.select{|u| u.transport == 2}.count
    @users =   User.all
    render :layout => "secondary_layout"
  end

  # only for admins to send announcements
  def announcement 
    admins = [2,45]
    redirect_to "/" and return if current_user.nil? or !admins.include?(current_user.id)
    users = User.all
    users.each do |user|
      Resque.enqueue(AnnouncementMailer, user.email, params[:subject], params[:message])
    end 
    redirect_to "/admin/"
  end 

  def checkin
    admins = [2,45]
    redirect_to "/" and return if current_user.nil? or !admins.include?(current_user.id)
    @teams = Team.where(:checkin=>0).order("name")
    render :layout => "secondary_layout"
  end 

  def judges 
    admins = [2,45]
    redirect_to "/" and return if current_user.nil? or !admins.include?(current_user.id)
    @teams = Team.where(:checkin=>1).order("name")
    render :layout => "secondary_layout"
  end 

  def results
    render :layout => "secondary_layout"
  end 

end
