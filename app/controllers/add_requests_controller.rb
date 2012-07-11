
class AddRequestsController < ApplicationController
  
  # Add request  
  # Send email to member and wait for conf 
  def create
    team = current_user.owned_team
    render :json => {:err => "present", :data => "Error adding"} and return  if team.blank? || team.member_count >= 4
    # Check if such user exists 
    user = User.find_by_id(params[:id])
    render :json => {:err => "present", :data => "No such user"} and return if user.blank?
    # existing team member ?
    render :json => {:err => "present", :data => "user is in another team"} and return if user.team.present?
    # Check if already added 
    req = AddRequest.where(:user_id => user.id, :team_id => team.id).first
    render :json => {:err => "present", :data => "Already Requested"} and return if req.present?
    # create a new add request
    request = AddRequest.new(:user_id =>params[:id], :team_id=> team.id, :team_name => team.name)  
    if request.save
      Resque.enqueue(RequestMailer,current_user.name,team.name,user.email,0)
      render :json => {:err => nil, :data => "Request sent via email"} and return 
    else  
      render :json => {:err => "present", :data => request.errors.full_messages.to_s} and return 
    end 
  end 

  # Add2 request  
  # Send email to member and wait for conf 
  def add2
    team = current_user.owned_team
    render :json => {:err => "present", :data => "Error adding"} and return  if team.blank? || team.member_count >= 4
    # Check if such user exists 
    user = User.find_by_handle(params[:handle])
    render :json => {:err => "present", :data => "No such user"} and return if user.blank?
    # existing team member ?
    render :json => {:err => "present", :data => "user is in another team"} and return if user.team.present?
    # Check if already added 
    req = AddRequest.where(:user_id => user.id, :team_id => team.id).first
    render :json => {:err => "present", :data => "Already Requested"} and return if req.present?
    # create a new add request
    request = AddRequest.new(:user_id =>user.id, :team_id=> team.id, :team_name => team.name)  
    if request.save
      Resque.enqueue(RequestMailer,current_user.name,team.name,user.email,0)
      render :json => {:err => nil, :data => "Request sent via email"} and return 
    else  
      render :json => {:err => "present", :data => request.errors.full_messages.to_s} and return 
    end 
  end

  def accept
    # check if team exists
    render :json => {:err =>"e1", :data => "Already in a team "} and return if current_user.team.present?
    # fetch team 
    team = Team.find_by_id(params[:id])
    # check team 
    render :json => {:err =>"e1", :data => "No such team"} and return  if team.blank?
    # check team 
    render :json => {:err =>"e1", :data => "Team already has 4 members !"} and return if team.member_count >= 4
    # Query for member  
    add_request = team.add_requests.find_by_user_id(current_user.id)
    # Check if member request exists 
    render :json => {:err =>"e2", :data => "No such request"} and return  if add_request.blank?
    # add to team member table 
    team_member = TeamMember.new(:user_id => current_user.id, :team_id => team.id, :user_handle=> current_user.handle)
    # save team member 
    team_member.save 
    # Increment team count and save
    team.update_attribute('member_count', team.member_count+1)
    # Find member to send email 
    owner = User.find_by_id(team.owner_id)
    # delete all join requests 
    current_user.join_requests.destroy_all
    # Delete add_req
    current_user.add_requests.destroy_all
    # Email member 
    Resque.enqueue(DecideTeamMailer, current_user.name, team.name, owner.email, 5)
    # return team 
    render :json => {:err => nil, :data => nil} and return 
  end 

  def destroy
    # fetch team 
    team = Team.find_by_id(params[:id])
    # check team 
    render :json => {:err =>"e1", :data => "No such team"} and return if team.blank?
    # Query for member  
    add_request = team.add_requests.find_by_user_id(current_user.id)
    # Check if member request exists 
    render :json => {:err =>"e2", :data => "No such request"} and return  if add_request.blank?
    # Find member to send email 
    owner = User.find_by_id(team.owner_id)
    # Delete add_req
    add_request.destroy
    # Email member 
    Resque.enqueue(DecideTeamMailer, current_user.name, team.name, owner.email, 6)
    # return team 
    render :json => {:err => nil, :data => nil} and return 
  end

end

  

