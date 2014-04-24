class Trips::User < ActiveRecord::Base
  belongs_to :user
  belongs_to :trip
end
