require 'rails_helper'

feature 'reviewing' do
  before {Restaurant.create name: 'pret'}

  # def leave_review(thoughts, rating)
  #   visit '/restaurants'
  #   click_link 'Review pret'
  #   fill_in 'Thoughts', with: thoughts
  #   select rating, from: 'Rating'
  #   click_button 'Leave Review'
  # end

  scenario 'displays an average rating for all reviews' do
    visit '/'
    click_link('Sign up')
    fill_in('Email', with: 'lala@example.com')
    fill_in('Password', with: 'testtest123')
    fill_in('Password confirmation', with: 'testtest123')
    click_button('Sign up')
    click_link 'Review pret'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    click_link 'Sign out'
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
    click_link 'Review pret'
    fill_in "Thoughts", with: "so so"
    select '5', from: 'Rating'
    click_button 'Leave Review'
    expect(page).to have_content('Average rating: ★★★★☆')
  end

  scenario 'allows users to leave a review using a form' do
    visit('/')
    click_link('Sign up')
    fill_in('Email', with: 'test@example.com')
    fill_in('Password', with: 'testtest')
    fill_in('Password confirmation', with: 'testtest')
    click_button('Sign up')
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

  scenario 'user can only delete their review' do
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
    click_link 'Delete Review'
    expect(page).to have_content 'Review deleted'
  end

end
