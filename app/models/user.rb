class User < ActiveRecord::Base
  include BCrypt

  has_many :created_events, class_name: "Event", foreign_key: :creator_id
  has_many :event_attendances, foreign_key: :attendee_id
  has_many :attended_events, through: :event_attendances, source: :event

  # has_many :event_attendees, through: :created_event

  has_secure_password

  validates_presence_of :password
  validates_uniqueness_of :email
  validates_presence_of :email
  validates :email, format: {with: /\w+@{1}\w+\.{1}[A-Za-z]+/}

end

