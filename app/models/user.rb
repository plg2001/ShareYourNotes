class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,:lastseenable,
         :recoverable, :rememberable, :validatable, :confirmable, :omniauthable , omniauth_providers: [:google_oauth2, :facebook]
  
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
  has_many :create_ratings
  has_many :comments
  has_many :visualizzaziones
 
  

  def self.from_omniauth(auth)
    access_token = auth.credentials.token
    refresh_token = auth.credentials.refresh_token
    expires_at = auth.credentials.expires_at
    
    user_image = auth.info.image
    name_split = auth.info.name.split(" ")
    user = User.where(email: auth.info.email).first
  
    if user
      # Se l'utente esiste già, aggiorna i valori solo se sono cambiati
      if user.google_drive_access_token != access_token ||
         user.google_drive_refresh_token != refresh_token ||
         user.google_drive_expires_at != expires_at
        user.update!(
          google_drive_access_token: access_token,
          google_drive_refresh_token: refresh_token,
          google_drive_expires_at: expires_at,
          profile_img_url: user_image
        )
      end
    else
      # Se l'utente non esiste, creane uno nuovo con i valori forniti
      password = Devise.friendly_token[0, 20]
      user = User.create!(
        provider: auth.provider,
        uid: auth.uid,
        username: name_split[0] + "" + "ShareYourNotes",
        name: name_split[0],
        email: auth.info.email,
        password: password,
        password_confirmation: password,
        google_drive_access_token: access_token,
        google_drive_refresh_token: refresh_token,
        google_drive_expires_at: expires_at,
        profile_img_url: user_image
      )
      user.skip_confirmation!
      user.save!
    end
  
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

