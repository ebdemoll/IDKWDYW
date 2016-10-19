# frozen_string_literal: true
require 'spec_helper'
require 'rails_helper'
# frozen_string_literal: true
describe 'Unauth user can sign in' do

  let!(:user_1) { FactoryGirl.create(:user) }

  feature 'Unauthorized can signup for website' do

    scenario 'User sees signup button in header' do
      visit '/'
      expect(page).to have_link 'Sign in with Facebook'
    end

    scenario 'User can successfully sign up' do
      login_with_facebook("DaveTirio")
      visit root_path
      expect(page).to have_content('Signed in as')
    end

  end
end
