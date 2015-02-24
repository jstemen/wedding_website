class Event < ActiveRecord::Base
  has_many :invitations
  has_many :guests, through: :invitations
  
  
end
