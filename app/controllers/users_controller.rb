class UsersController < ApplicationController
 
  # Create user only if registration form is complete
  def create
    redirect_to "/" if session[:auth].blank?
    auth = session[:auth]
    user = User.new 
    user.uid = auth["uid"]
    user.name = params[:name]
    user.email = params[:email] 
    user.handle = auth["extra"]["raw_info"]["login"]
    user.avatar = auth["extra"]["raw_info"]["avatar_url"]
    user.tee = params[:tee] if params[:tee].present?
    user.gender = params[:gender]  if params[:gender].present?
    user.transport = params[:transport] if params[:transport].present?
      if user.save
        Resque.enqueue(RegisterMailer, user.id)
        session[:user_id] = user.id
        redirect_to "/"
      else
        flash[:errors] = user.errors
        @name = params[:name]
        @email = params[:email]
        @teams = Team.all
        @users = User.all
        @members = @users.index_by(&:id)
        @avatar = auth["extra"]["raw_info"]["avatar_url"]
        @handle = auth["extra"]["raw_info"]["login"]
        render "home/index"
      end 
  end  

  def update
    if current_user
      current_user.name = params[:name] if params[:name].present?
      current_user.tee = params[:tee] if params[:tee].present?
      current_user.gender = params[:gender] if params[:gender].present?
      current_user.transport = params[:transport] if params[:transport].present?
      current_user.save
    end
    redirect_to "/"
  end 

end