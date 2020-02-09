require 'rails_helper'

feature 'User can login with 3rd party OAuth provider' do
  background { visit new_user_session_path }
  given!(:user_registered) { create(:user, email: 'registered@user.com') }

  describe 'User sign in through Github' do
    vcr_options = { :record => :new_episodes }

    scenario "OAuth provider has user's email", vcr: vcr_options do
      mock_auth_github('new@user.com')
      click_on 'Login with GitHub'

      expect(page).to have_content 'Successfully authenticated from github account.'
    end

    scenario "OAuth provider has user's email and user has an account", vcr: vcr_options do
      mock_auth_github('registered@user.com')
      click_on 'Login with GitHub'

      expect(page).to have_content 'Successfully authenticated from github account.'
    end

    scenario "OAuth provider doesn't have user's email", vcr: vcr_options do
      mock_auth_github(email: nil)
      click_on 'Login with GitHub'

      expect(page).to have_content 'You need a Github account in order to login'
    end

    scenario "Log Out", vcr: vcr_options do
      mock_auth_github('new@user.com')
      click_on 'Login with GitHub'

      click_on 'Log Out'
      expect(page).to have_content 'You need a Github account in order to login'
    end
  end
end
