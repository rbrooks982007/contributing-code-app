class AnnouncementMailer
  @queue = :mailer_queue   
  def self.perform(to_email,subject,message)
    Notifier.admin_mailer(to_email,subject,message).deliver    
  end
end
