class TeamsController < ApplicationController
 before_filter :require_user
  
  def new 
  end 

  # crate a new team 
  def create  
    render :json => {:err => "present", :data =>"Cannot create a team"} and return  if current_user.team.present?
    team = Team.new
    team.name = params[:name] 
    team.desc = params[:desc]
    team.owner_id = current_user.id
    team.owner_handle = current_user.handle
    team.member_count = 1
    team.image = params[:image]
    # check for validations before save
    if team.save
      # Create a team memeber 
      member = TeamMember.new(:team_id => team.id, :user_id => team.owner_id, :user_handle => team.owner_handle)
      member.save
      # delete the current_users/ team owner's requests
      current_user.join_requests.destroy_all
      current_user.add_requests.destroy_all
      render :json => {:err => nil, :data => team} and return 
    else
      render :json => {:err => "present", :data => team.errors.full_messages.to_s} and return 
    end 
  end 
 
  # fetch all teams 
  def index 
    @teams = Team.all
  end 

  def update 
    team = Team.find_by_owner_id(current_user.id)
    render :json => {:err => "present", :data => nil} and return if team.blank?
    team.image = params[:image] if params[:image].present?
    team.name = params[:name]
    team.desc = params[:desc]
    # Team.update(team.id,:name=> params[:name],:desc=>params[:desc]) 
    if team.save 
      # team.update_attribute("desc",params[:desc])
      render :json => {:err => nil, :data => team} and return 
    else 
      render :json => {:err => "present", :data => team.errors.full_messages.to_s} and return 
    end 
  end 

  # Delete whole team 
  # Inform all members via email 
  def destroy
    team = current_user.owned_team
    render :json => {:err => nil, :data => nil} and return if team.blank?
    team_members = team.team_members
    # collect all users in team 
    users = User.where(:id => team_members.collect(&:user_id)).index_by(&:id)
    # Send email to each memeber
    team_members.each do |member|
      # send email to all except owner
      Resque.enqueue(DecideTeamMailer, current_user.name, team.name, users[member.user_id].email, 4) if member.user_id != current_user.id
    end
    # destroy team,team_members and add_requests,join_requests
    team.destroy
    render :json => {:err => nil, :data => nil} and return 
  end 
  
end
