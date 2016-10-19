# frozen_string_literal: true
require 'spec_helper'
require 'rails_helper'
# frozen_string_literal: true
describe 'Unauth user can sign in' do

  let!(:user_1) { FactoryGirl.create(:user) }

  feature 'Unauthorized can signup' do

    scenario 'User sees signup button in header' do
      visit '/'
      expect(page).to have_link 'Sign in with Google'
    end

    scenario 'User can click signup button' do
      visit '/'
      sign_in_as user_1

      expect(page).to have_content('Signed in as #{user_1.name}')
    end

    scenario 'User enters information and signs up' do
      visit '/'
      click_link 'Sign up'

      fill_in 'Email', with: 'test_user@gmail.com'
      fill_in 'First name', with: 'test'
      fill_in 'Last name', with: 'name'
      fill_in 'Password', with: 'scooped'
      fill_in 'Password confirmation', with: 'scooped'

      click_button 'Sign up'

      expect(page).to have_content('Signed in as test_user@gmail.com')
    end

    scenario 'User enters email that is already in the system' do
      User.create(
        email: 'second_user@gmail.com',
        first_name: 'test',
        last_name: 'test',
        password: 'scooped'
      )

      visit '/'
      click_link 'Sign up'

      fill_in 'Email', with: 'second_user@gmail.com'
      fill_in 'First name', with: 'test'
      fill_in 'Last name', with: 'name'
      fill_in 'Password', with: 'scooped'
      fill_in 'Password confirmation', with: 'scooped'

      click_button 'Sign up'

      expect(page).to have_content('Email has already been taken')
    end

    scenario 'User enters a password confirmation that does not match password' do
      visit '/'
      click_link 'Sign up'

      fill_in 'Email', with: 'third_user@gmail.com'
      fill_in 'First name', with: 'test'
      fill_in 'Last name', with: 'name'
      fill_in 'Password', with: 'scooped'
      fill_in 'Password confirmation', with: 'blahbl'

      click_button 'Sign up'

      expect(page).to have_content(
        'Password confirmation doesn\'t match Password'
      )
    end

    scenario 'User enters a password that is too short' do
      visit '/'
      click_link 'Sign up'

      fill_in 'Email', with: 'fourth_user@gmail.com'
      fill_in 'First name', with: 'test'
      fill_in 'Last name', with: 'name'
      fill_in 'Password', with: 'scoop'
      fill_in 'Password confirmation', with: 'scoop'

      click_button 'Sign up'

      expect(page).to have_content(
        'Password is too short (minimum is 6 characters)'
      )
    end
  end
end
