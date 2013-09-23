class Team < ActiveRecord::Base

=begin
  include Mongoid::Document

  field :s, as: :slug, type: String

  has_and_belongs_to_many :members, class_name: "User", inverse_of: :teams
  belongs_to :creator, class_name: "User", inverse_of: :teams_created
=end

  belongs_to :creator, class_name: "User"
  has_many :memberships, class_name: "TeamMembership"
  has_many :members, through: :memberships, source: :user

  validates :creator, presence: true #,  uniqueness: true <<TODO: This breaks tests weidly. 
  validates :slug, presence: true,  uniqueness: true #<<TODO: This breaks tests weidly. 

  def self.by(user)
    new(creator: user)
  end

  def defined_with(options)
    self.slug = options[:slug]
    self.members = User.find_in_usernames(options[:usernames].to_s.scan(/\w+/))
    self
  end

  def usernames
    members.map(&:username)
  end

  def includes?(user)
    creator == user || members.include?(user)
  end
end
