module OmniauthMacros
  def mock_auth_github(email)
    email = email[0] if email.class == Hash

    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => :github,
      'uid' => '123545',
      'info' => { 'email' => email, 'nickname' => 'dmikhr' }
    })
  end
end
