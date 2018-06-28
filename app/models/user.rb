class User < ApplicationRecord
  has_many :posts
  has_many :comments
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, 
         omniauth_providers: [:facebook, :twitter]
  acts_as_voter

  def self.from_faccebook_omniauth(auth)
	  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	    user.email = auth.info.email
	    user.password = Devise.friendly_token[0,20]
	    user.name = auth.info.name   
	    user.provider = auth.provider
	  end
  end

  def self.from_twitter_omniauth(auth)
	  where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
	    user.email = auth.info.nickname + "@twitter.com"
	    user.password = Devise.friendly_token[0,20]
	    user.name = auth.info.name   
	    user.provider = auth.provider
	  end
  end
end
