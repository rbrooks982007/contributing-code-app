class RegisterMailer
  @queue = :mailer_queue   
  def self.perform(user_id)
    user = User.find(user_id)
    Notifier.register_email(user.name, user.email).deliver
  end
end