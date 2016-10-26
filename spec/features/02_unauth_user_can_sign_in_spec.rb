require 'spec_helper'
require 'rails_helper'
require 'factory_girl_rails'

describe 'Unauth user can sign in' do

  let!(:user_1) { FactoryGirl.create(:user) }

  feature 'Unauthorized can login' do

    scenario 'User sees login button in header' do
      visit '/'
      expect(page).to have_link 'Log In'
    end

    scenario 'User can click login button and login' do
      visit '/'
      click_link 'Log In'
      fill_in 'Email', with: user_1.email
      fill_in 'Password', with: user_1.password
      click_button 'Log In'

      expect(page).to have_content("Signed in as #{user_1.name}")
    end

    scenario 'Logged in User can log out from button in header' do
      visit '/'
      click_link 'Log In'
      fill_in 'Email', with: user_1.email
      fill_in 'Password', with: user_1.password
      click_button 'Log In'
      click_link 'Sign Out'

      expect(page).to have_link 'Log In'
    end

    scenario 'User enters incorrect password and cannot login' do
      visit '/'
      click_link 'Log In'
      fill_in 'Email', with: user_1.email
      fill_in 'Password', with: 'scoop'
      click_button 'Log In'

      expect(page).to_not have_content("Signed in as #{user_1.email}")
    end

  end
end
