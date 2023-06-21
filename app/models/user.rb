class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable, omniauth_providers: %i[facebook]


 

         
  has_many :richiesta_admins


  after_create :send_welcome_email

  private

  def user_params
    params.require(:user).permit(:confirmed_at)
  end

  def send_welcome_email
    UserMailer.welcome_email(self).deliver_now
  end

end

