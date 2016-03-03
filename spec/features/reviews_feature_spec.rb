require 'rails_helper'

feature 'reviewing' do
  before {Restaurant.create name: 'pret'}

  scenario 'allows users to leave a review using a form' do
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
    # click_link 'Sign in'
    # fill_in('Email', with: 'lalala.com')
    # fill_in('Password', with: 'password123456')
    # click_button 'Log in'
    click_link 'Add a restaurant'
    fill_in 'Name', with: 'Pret'
    click_button 'Create Restaurant'
    click_link 'Review Pret'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

  scenario 'user can only leave 1 review per restaurant' do
    visit '/'
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
    click_link 'Review pret'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    click_link 'Review pret'
    expect(page).to have_content 'has reviewed this restaurant already'
  end

end
