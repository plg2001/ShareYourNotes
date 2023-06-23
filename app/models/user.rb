class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, :omniauth_providers => [:facebook]
    
  has_many :richiesta_admins

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
    user.email = auth.info.email
    user.password = Devise.friendly_token[0,20]
    end
    end
    
    def self.new_with_session(params, session)
    super.tap do |user|
    if data = session["devise.facebook_data"] && session["devise.facebook_data"]
    ["extra"]["raw_info"]
    user.email = data["email"] if user.email.blank?
    end
    end
    end

  after_create :send_welcome_email

  private

  def user_params
    params.require(:user).permit(:confirmed_at)
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end

end

