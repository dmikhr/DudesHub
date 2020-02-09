require 'rails_helper'

feature 'User can see the list of own repositories' do
  given(:user) { create(:user) }
  given(:user_other) { create(:user) }
  given!(:repos) { create_list(:repo, 3, user: user) }
  given!(:repos_other) { create_list(:repo, 3, user: user_other) }

  context 'User' do
    before { sign_in_github(user) }

    scenario 'User see own repositories list' do
      expect(page).to have_content 'Github repositories for'

      within '.repos' do
        repos.each { |repo| expect(page).to have_content repo.full_name }
      end
    end

    scenario 'User cannot see repositories of another user' do
      within '.repos' do
        repos_other.each { |repo| expect(page).to_not have_content repo.full_name }
      end
    end

    scenario 'User see nav bar' do
      expect(page).to have_content 'Main page'
    end
  end

  context 'Guest' do
    before { visit root_path }

    scenario 'Guest see login page' do
      expect(page).to have_content 'You need a Github account in order to login'
    end

    scenario 'Guest cannot see nav bar' do
      expect(page).to_not have_content 'Main page'
    end
  end
end
