require 'rails_helper'

feature 'reviewing' do
  before {Restaurant.create name: 'pret'}

  scenario 'allows users to leave a review using a form' do
    visit '/restaurants'
    click_link 'Review pret'
    fill_in "Thoughts", with: "so so"
    select '3', from: 'Rating'
    click_button 'Leave Review'
    expect(current_path).to eq '/restaurants'
    expect(page).to have_content('so so')
  end

end
