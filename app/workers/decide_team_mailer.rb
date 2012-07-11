class DecideTeamMailer
  @queue = :mailer_queue
  def self.perform(sender_name,team_name,to_email,type)
    Notifier.decide_team_email(sender_name, team_name, to_email, type).deliver
  end
end