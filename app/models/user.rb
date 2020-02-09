class User < ApplicationRecord
  has_many :authorizations, dependent: :destroy
  has_many :repos, dependent: :destroy
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]


  def self.find_for_oauth(auth)
    FindForOauth.new.call(auth)
  end

  def create_authorization!(auth)
    self.authorizations.create!(provider: auth.provider, uid: auth.uid)
  end
end
