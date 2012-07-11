class Team < ActiveRecord::Base
  belongs_to :user 

  has_many :team_members, :dependent => :destroy
  has_many :join_requests, :dependent => :destroy
  has_many :add_requests, :dependent => :destroy

  validates_presence_of :name
  validates_uniqueness_of :name 
  validates_uniqueness_of :owner_id, :message => "Cant own many teams"

  mount_uploader :image, TeamImageUploader
end
