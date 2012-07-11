class JoinRequestsController < ApplicationController

  # User joins existing teams 
  # Joinrequest is created and en email is sent to owner
  def create
    # check if the user is already in a team 
    member = current_user.team_member
    render :json => {:err => "e1", :data => "You are already in a team !"} and return  if member.present?
    # Get the team record  
    team = Team.find_by_id(params[:id])
    # check if there exists a team with the id in params
    render :json => {:err => "e2", :data => "No such team !"} and return  if team.blank?
    # Check for team size
    render :json => {:err => "e3", :data => "Team has already has four members."} and return  if team.member_count == 4
    # Add to team members 
    join_request = JoinRequest.new(:team_id => team.id, :user_id => current_user.id, :user_handle => current_user.handle)
    # save teammember 
    join_request.save
    # Query owner user object 
    owner = User.find(team.owner_id)
    # Now send an accept email to owner 
    Resque.enqueue(RequestMailer, current_user.name, team.name, owner.email, 1)
    render :json => {:err =>nil, :data => "Request sent to team owner. You will receive an email if the Team owner accepts you."} and return 
  end 

  # Owner of a team accepts the join request 
  # All other join requests are deleted 
  # An email is sent to the requester 
  def accept
    # Fetch to check if owner 
    team = current_user.owned_team
    # check if team exists
    render :json => {:err =>"e1", :data => "No such team"}and return if team.blank?
    # check team capacity 
    render :json => {:err =>"e1", :data => "Team already has 4 members !"} and return if team.member_count >= 4
    # Query for member  
    join_request = team.join_requests.find_by_user_id(params[:id])
    # Check if member request exists 
    render :json => {:err =>"e2", :data => "No such request"} and return if join_request.blank?
    # add to team member table 
    team_member = TeamMember.new(:user_id => join_request.user_id, :team_id => join_request.team_id, :user_handle=> join_request.user_handle)
    # save team member 
    team_member.save 
    # Increment team count and save
    team.update_attribute('member_count', team.member_count+1)
    # Find member to send email 
    member = User.find(params[:id])
    # delete all join requests 
    member.join_requests.destroy_all
    # delete all add  requests
    member.add_requests.destroy_all
    # Email member 
    Resque.enqueue(DecideTeamMailer, current_user.name, team.name, member.email, 1)
    # return team 
    render :json => {:err => nil, :data => nil} and return 
  end


  # User request is decline by team owner 
  # That particular join request record is deleted 
  # Requestor is notified via email 
  def decline
    # fetch the team 
    team = current_user.owned_team
    render :json => {:err =>"e1", :data => "No such team"} and return  if team.blank?
    # Fetch the request
    join_request = team.join_requests.find_by_user_id(params[:id])
    render :json => {:err =>"e2", :data => "No such request"} and return  if join_request.blank?
    # Get user to send email 
    member = User.find(join_request.user_id)
    # Deelte request 
    join_request.destroy
    # Send email 
    Resque.enqueue(DecideTeamMailer, current_user.name, team.name, member.email, 0)
    # return 
    render :json => {:err =>nil, :data => nil} and return 
  end 

end