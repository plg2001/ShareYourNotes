class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, omniauth_providers: %i[facebook]
    
  has_many :richiesta_admins
  has_many :notes

  def self.from_omniauth(auth)
    name_split = auth.info.name.split(" ")
    user = User.where(email: auth.info.email).first
    user ||= User.create!(provider: auth.provider, uid: auth.uid,username: name_split[0]+ ""+"ShareYourNotes", name: name_split[0], email: auth.info.email, password: Devise.friendly_token[0, 20])
    user.skip_confirmation!
    user.save!
      user
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

