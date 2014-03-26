class SignUpValidator < ActiveModel::Validator
  def validate(record)
    if User.find_by_email( record.email )
      record.errors.add( :email, "has already signed up" )
    end    
  end
end

class UserInvite < ActiveRecord::Base
  belongs_to :user
  attr_accessible :email, :signed_up
  EMAIL_R=/\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i
  validates :email, presence: true, format: EMAIL_R, uniqueness: { case_sensitive: false, message: "has already been invited !" }

  validates_with SignUpValidator
end