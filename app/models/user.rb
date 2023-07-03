class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable , omniauth_providers: %i[facebook] 
  
         validates :password, presence: true, length: { minimum: 6 }, if: :password_required?
         validates :password_confirmation, presence: true, if: :password_required?
         
         attr_accessor :current_password
         
         def password_required?
           password.present? || password_confirmation.present?
         end
         
  has_many :richiesta_admins, dependent: :destroy
  has_many :notes, dependent: :destroy
  has_many :favourites, dependent: :destroy
  has_many :favourite_notes, through: :favourites, source: :note
  has_many :ratings
  has_many :conversation, :foreign_key => :sender_id

  after_create :create_default_conversation


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

  def user_params
    params.require(:user).permit(:name, :email, :password, favourite_notes_ids: [])
  end  

  def each_with_index
   @user = User.all
  end


end

