class User < ApplicationRecord

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :timeoutable, :omniauthable, omniauth_providers: [:twitter]
  mount_uploader :avatar, AvatarUploader
  has_many :notes
  has_many :posts
  def self.from_omniauth(auth)
     find_or_create_by(provider: auth["provider"], uid: auth["uid"]) do |user|
       user.provider = auth["provider"]
       user.uid = auth["uid"]
       user.username = auth["info"]["nickname"]
       user.image_url = auth_hash["info"]["image"]
     end
   end

   def self.new_with_session(params, session)
     if session["devise.user_attributes"]
       new(session["devise.user_attributes"]) do |user|
         user.attributes = params
       end
     else
       super
     end
   end
  def soft_delete
    update(deleted_at: Time.now)
  end
  def active_for_authentication?
    !deleted_at
  end
  def inactive_message
    !deleted_at ? super : :deleted_account
  end
end
