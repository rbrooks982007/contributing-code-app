class RequestMailer
  @queue = :mailer_queue   
  def self.perform(sender_name,team_name,user_email,type)
    Notifier.join_team_email(sender_name, team_name, user_email, type).deliver
  end
end