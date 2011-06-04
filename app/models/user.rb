class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :phone, :password, :password_confirmation, :remember_me

  has_many :lists, :dependent => :destroy

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise_facebook_data"] && session["devise.facebook_data"]["extra"]["user_hash"]
        user.email = data["email"]
      elsif data = session["devise_foursquare_data"] && session["devise_foursquare_data"]["extra"]["user_hash"]
        user.email = data["email"]
      end
    end
  end

  def self.find_for_facebook_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["email"])
      user
    else # Create a user with a stub password.
      User.create!(:email => data["email"], :password => Devise.friendly_token[0,20])
    end
  end

  def self.find_for_foursquare_oauth(access_token, signed_in_resource=nil)
    data = access_token['extra']['user_hash']
    if user = User.find_by_email(data["contact"]["email"])
      user
    else # Create a user with a stub password.
      #logger.debug data
      User.create!(:email => data["contact"]["email"], :phone => data["contact"]["phone"], :password => Devise.friendly_token[0,20])
    end
  end
end
