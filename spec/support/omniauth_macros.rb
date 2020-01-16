module OmniauthMacros
  def mock_auth(provider, email)
    # для корректной отработки записи вида mock_auth(:github, email: nil)
    email = email[0] if email.class == Hash

    OmniAuth.config.mock_auth[provider] = OmniAuth::AuthHash.new({
      'provider' => provider.to_s,
      'uid' => '123545',
      'info' => { 'email' => email }
    })
  end
end
