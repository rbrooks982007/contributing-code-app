class User < ActiveRecord::Base
  has_one :team_member
  has_many :join_requests
  has_many :add_requests
  has_one :owned_team, :foreign_key => 'owner_id', :class_name => 'Team'
  has_one :team, :through => :team_member
  
  
  validates_presence_of   :handle
  validates_presence_of   :email , :message => "Email required!"
  validates_uniqueness_of :handle
  validates_format_of     :email, :with => %r{.+@.+\..+}


end
