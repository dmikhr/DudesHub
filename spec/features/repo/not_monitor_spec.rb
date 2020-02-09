require 'rails_helper'

feature 'can see the list of own not monitored repositories' do
  given(:user) { create(:user) }
  given(:user_other) { create(:user) }
  given!(:repos_not_monitored) { create_list(:repo, 2, user: user) }
  given!(:repos_not_monitored_other) { create_list(:repo, 2, user: user_other) }
  given!(:repos_monitored) { create_list(:repo, 3, monitored: true, user: user) }
  given!(:repos_monitored_other) { create_list(:repo, 3, monitored: true, user: user_other) }

  context 'User' do
    before do
      sign_in_github(user)
      visit not_monitor_repos_path
    end

    scenario 'see own not monitored repositories' do
      expect(page).to have_content 'Not monitored repositories'

      within '.repos' do
        repos_not_monitored.each { |repo| expect(page).to have_content repo.full_name }
      end
    end

    scenario 'cannot see own monitored repositories' do
      within '.repos' do
        repos_monitored.each { |repo| expect(page).to_not have_content repo.full_name }
      end
    end

    scenario 'cannot see not monitored repositories of another user' do
      within '.repos' do
        repos_not_monitored_other.each { |repo| expect(page).to_not have_content repo.full_name }
      end
    end

    scenario 'cannot see monitored repositories of another user' do
      within '.repos' do
        repos_monitored_other.each { |repo| expect(page).to_not have_content repo.full_name }
      end
    end

    scenario 'enable repository monitoring' do
      within page.all("tr[contains(@class, 'repo')]")[0] do
        click_on 'Enable'
      end
      expect(page).to have_content 'Click Disable in order to stop monitoring'
    end
  end

  scenario 'Guest see login page' do
    visit not_monitor_repos_path
    expect(page).to have_content 'You need a Github account in order to login'
  end
end
