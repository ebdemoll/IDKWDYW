require 'spec_helper'
require 'rails_helper'

describe 'Unauth user can sign in' do

  feature 'Unauthorized can signup' do

    scenario 'User sees signup button in header' do
      visit '/'
      expect(page).to have_link 'Sign Up'
    end

    scenario 'User can click signup button' do
      visit '/'
      click_link 'Sign Up'
      fill_in 'Name', with: "Foobington III"
      expect(page).to have_field('Email')
      expect(page).to have_field('Password')
      expect(page).to have_field('Confirmation')
    end

    scenario 'User enters information and signs up' do
      visit '/'
      click_link 'Sign Up'
      fill_in 'Name', with: "Foobington III"
      fill_in 'Email', with: 'test_user@gmail.com'
      fill_in 'Password', with: 'scooped'
      fill_in 'Confirmation', with: 'scooped'
      click_button 'Create my account'

      expect(page).to have_content('Signed in as Foobington III')
    end

    scenario 'User enters email that is already in the system' do
      User.create(
        name: "Not Foobington",
        email: 'second_user@gmail.com',
        password: 'testing'
      )

      visit '/'
      click_link 'Sign Up'
      fill_in 'Name', with: "Foobington III"
      fill_in 'Email', with: 'second_user@gmail.com'
      fill_in 'Password', with: 'scooped'
      fill_in 'Confirmation', with: 'scooped'
      click_button 'Create my account'

      expect(page).to have_content('Email has already been taken')
    end

    scenario 'User enters a password confirmation that does not match password' do
      visit '/'
      click_link 'Sign Up'
      fill_in 'Name', with: "Foobington III"
      fill_in 'Email', with: 'third_user@gmail.com'
      fill_in 'Password', with: 'scooped'
      fill_in 'Confirmation', with: 'blahbl'
      click_button 'Create my account'

      expect(page).to have_content(
        'Password confirmation doesn\'t match Password'
      )
    end

    scenario 'User enters a password that is too short' do
      visit '/'
      click_link 'Sign Up'
      fill_in 'Name', with: "Foobington III"
      fill_in 'Email', with: 'fourth_user@gmail.com'
      fill_in 'Password', with: 'scoop'
      fill_in 'Confirmation', with: 'scoop'
      click_button 'Create my account'

      expect(page).to have_content(
        'Password is too short (minimum is 6 characters)'
      )
    end
  end
end
