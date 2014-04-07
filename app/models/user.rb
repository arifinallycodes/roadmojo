class User < ActiveRecord::Base
  include FriendlyId
  # for uploading using CarrierWave
  mount_uploader :avatar, ImageUploader

  PRIVILEGED_EMAILS = ['thirthappa.kaushik@gmail.com','ari@roadmojo.com','ajay@roadmojo.com', 'kaushik@roamdojo.com', 'ashish@roadmojo.com']

  RESERVED_USERNAMES = %w( home terms-and-conditions copyright features about-us explore users )

  friendly_id :username, use: :slugged

  # === Associations ===
  has_many :trips
  has_many :user_invites
  has_many :authentications
  has_many :users_liked_trips
  has_many :liked_trips, through: :users_liked_trips, source: :trip #, foreign_key: 'trip_id'

  # for follow options
  has_many :user_followed_places
  has_many :following_places, through: :user_followed_places, source: :place

  # === Devise Setup ===
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  # Once we move out of Heroku, add :async module to send emails in the background
  devise :database_authenticatable, :registerable, :lockable, :confirmable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :async


  
  # Setup accessible (or protected) attributes for your model
  # Provider and uid are needed for OAuth integration
  validates_presence_of :username
  validates :username, 
            format: 
                  { 
                    with: /\A[a-zA-Z0-9_\-.]+\Z/, 
                    multiline: false,
                    message: "format is incorrect"
                  },
            uniqueness: {
                    case_sensitive: false
                  },
            length:
                  {
                    minimum: 2,
                    maximum: 15,
                    too_short: "should have at least %{count} characters",
                    too_long: "should not have more than %{count} characters"
                  }

  #validate :username_email
  validates :email,uniqueness: true
  validates :age, numericality: { only_integer: true, greater_than: 0 }, if: "self.created_at and self.age != '' and !self.age.nil?"
  # validates :age, numericality: { only_integer: true, greater_than: 0 }, if: "self.created_at"

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  attr_accessible :username, :email, :password, :password_confirmation, 
                  :avatar, :full_name, :age, :gender, :desc, :current_loc,
                  :remember_me, :provider, :uid, :login, :fb_authentication_token
  # attr_accessible :title, :body

  GENDER = %w(Male Female)

  # return the instance object for Facebook api via Koala if user is signed in
  # via Facebook (which would mean he/she has fb_authentication_token) else return nil
  def new_koala_fb_client
    self.fb_authentication_token ? Koala::Facebook::API.new( self.fb_authentication_token ) : nil
  end

  def self.find_for_provider_oauth(auth, provider, signed_in_resource = nil)
    if provider == "facebook"
      user = User.where(email: auth.info.email).first
    elsif provider == "twitter"
      user = User.where(:provider => auth.provider, :twitter_uid => auth.uid).first
    end
    # if user.nil?
    #     user = User.new(
    #       name: auth.extra.raw_info.name,
    #       email: auth.info.email.blank? ? "" : auth.info.email,
    #       password: Devise.friendly_token[0,20]
    #     )
    #     user.skip_confirmation!
    #     user.save!
    # end
  end

  def self.find_for_twitter_oauth(auth, provider, signed_in_resource=nil)

    # if user
    #   return user
    # else
    #   registered_user = User.where(:email => auth.uid + "@twitter.com").first
    #   if registered_user
    #     return registered_user
    #   else

    #     user = User.create(name:auth.extra.raw_info.name,
    #                         provider:auth.provider,
    #                         uid:auth.uid,
    #                         email:auth.uid+"@twitter.com",
    #                         password:Devise.friendly_token[0,20],
    #                       )
    #   end

    # end
  end

  # Collect the places that the user is following
  def ordered_places_following
    self.following_places.select( 'places.id, places.name' )
  end

  # returns of ids of places that the user is following from user table
  def ids_of_following_places
    self.following_places.select( 'places.id' ).uniq
  end

  # returns if the trip has been liked by the user or not
  def liked_trip?( id )
    self.liked_trips.find_by_id( id )
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      facebook_data = session["devise.facebook_data"]
      if data = facebook_data && facebook_data["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
        # Line below is responsible for confirming user when signing in through FB.
        # params are checked to make sure that confirmation happens during create
        # action instead of new in registrations controller.
        if params.present?
          user.provider = facebook_data["provider"]
          user.uid = facebook_data["uid"]
          user.password = Devise.friendly_token[0, 20]
          user.fb_authentication_token = facebook_data["credentials"]["token"]

          user.confirmed_at = DateTime.now if user.valid?
        end
      end
    end
  end

  def draft_trips
    self.trips.where('draft_version=?',true)
  end

  private

  # Validator for email and username presence
  # def username_email
  #   found_by_email = User.scoped_by_email(email).first
  #   return true if found_by_email == self
  #   self.username.downcase!
  #   if found_by_email
  #     message = "has already been taken."
  #     if found_by_email[:provider]
  #       message << " Please sign in with #{found_by_email[:provider]}."
  #     end
  #     errors.messages[:email] = ["#{message} If you wish to reset your password please click the link below."]
  #   elsif User.where("lower(username) = ?", username.downcase).any?
  #     errors.messages[:username] = ["has already been taken"]
  #   elsif User::RESERVED_USERNAMES.include?( username )
  #     errors.messages[:username] = ["is reserved. Please choose some other username"]
  #   end
  # end


  # Overriding Devise to setup username to login.
  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end
end
