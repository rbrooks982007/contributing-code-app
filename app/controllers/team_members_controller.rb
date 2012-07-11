class TeamMembersController < ApplicationController

  def api_members
    team = current_user.owned_team
    render :json => {:err => nil , :data => nil } and return if team.blank?
    @team_members = team.team_members
    member_ids = @team_members.collect(&:user_id)
    @members = User.where(:id => member_ids).index_by(&:id)
    @team_members = @team_members - [current_user.team_member]
    @owner = current_user.team_member
    render :json => {:err => nil, :data => render_to_string(partial: "partials/myteam/members") } and return 
  end
  
  # Remove a memeber from a team 
  # Can be doen only by the owner 
  # Notify via email 
  def destroy
    # find current user's team
    team = current_user.owned_team
    render :json => {:err =>"e1", :data => "No such team"} and return  if team.blank?
    # Check if the user is a member of the team 
    team_member = team.team_members.find_by_user_id(params[:id])
    render :json => {:err =>"e3", :data => "No such memeber in team"} and return  if team_member.blank? 
    # check if id is not current_user/team owner
    render :json => {:err =>"e2", :data => "Cannot delete owner"}  and return if team.owner_id == team_member.user_id
    # Find member to email 
    member = User.find(team_member.user_id)
    # delete team memebr 
    team_member.destroy
    # Decrease team count and save 
    team.update_attribute('member_count', team.member_count-1)
    # Email user as removed form team 
    Resque.enqueue(DecideTeamMailer, current_user.name, team.name, member.email, 3) 
    render :json => {:err => nil, :data => nil} and return 
  end 
  
  
  # user leaves team 
  # Remove team_member
  # decrease count in team 
  # Email owner 
  def leave
    # Get the member info 
    team_member = current_user.team_member
    # return error if user has no team
    redirect_to "/" if team_member.blank? 
    # Find the team
    team = current_user.team
    redirect_to "/" if team.blank?
    # Decrease team count and save 
    team.update_attribute('member_count', team.member_count-1)
    # delete team member
    team_member.destroy
    # email
    owner = User.find(team.owner_id)
    Resque.enqueue(DecideTeamMailer, current_user.name, team.name, owner.email, 2)
    redirect_to "/"
  end 

end