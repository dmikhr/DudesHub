module FeatureHelpers
  def sign_in_github(user)
    visit new_user_session_path

    mock_auth_github(user.email)

    click_on 'Login with GitHub'
  end
end
