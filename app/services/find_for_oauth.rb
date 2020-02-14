class FindForOauth
  attr_reader :auth

  def call(auth)
    authorization = Authorization.find_by(provider: auth.provider, uid: auth.uid.to_s)
    return authorization.user if authorization

    email = auth.info[:email]
    user = User.find_by(email: email)
    if user
      user.create_authorization!(auth)
    else
      nickname = auth.info[:nickname]
      password = Devise.friendly_token[0, 20]
      User.transaction do
        user = User.create!(email: email, nickname: nickname, password: password,
                            password_confirmation: password)
        user.create_authorization!(auth)
      end
    end

    user
  end
end
