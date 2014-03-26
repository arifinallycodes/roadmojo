class SpecialEmail < ActiveRecord::Base
  attr_accessible :email

  validates :email, presence: true, uniqueness: true, format: { with: /\A[^@]+@([^@\.]+\.)+[^@\.]+\z/ } 
end
