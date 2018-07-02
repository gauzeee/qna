class User < ApplicationRecord
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :likes
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy
  # Include default devise modules. Others available are:
  #  :lockable, :timeoutable and
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :confirmable, :omniauthable,
         omniauth_providers: [:vkontakte, :github]
  validates :email, presence: true

  def author_of?(item)
    id == item.user_id
  end

  def self.find_for_oauth(auth)
    authorization = Authorization.where(provider: auth.provider, uid: auth.uid.to_s).first
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.where(email: email).first

    unless user
      email ||= "#{Devise.friendly_token[0, 5]}_change@me.please"
      password = Devise.friendly_token[0, 20]
      user = User.new(email: email, password: password, password_confirmation: password)

      user.skip_confirmation!
      user.save
    end

    user.create_authorization(auth)
    user
  end

  def create_authorization(auth)
    self.authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def no_email?
    email =~ /change@me.please/
  end
end
