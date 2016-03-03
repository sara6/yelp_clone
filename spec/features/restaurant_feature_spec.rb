require 'rails_helper'

feature 'restaurants' do
  context 'no restaurants have been added' do
    scenario 'should display a prompt to add a restaurant' do
      visit '/restaurants'
      expect(page).to have_content 'No restaurants yet'
      expect(page).to have_link 'Add a restaurant'
    end
  end

  context 'restaurants have been added' do
    before do
      Restaurant.create(name: 'pret')
    end

      scenario 'display restaurants' do
        visit '/restaurants'
        expect(page).to have_content('pret')
        expect(page).not_to have_content('No restaurants yet')
      end
  end

  context 'creating restaurants' do

    scenario 'prompts user to fill out a form, then displays the new restaurant' do
      visit '/restaurants'
      click_link 'Sign up'
      fill_in 'user_email', with: 'loulou@lala.com'
      fill_in 'user_password', with: 'password1245'
      fill_in 'user_password_confirmation', with: 'password1245'
      click_button 'Sign up'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'pret'
      click_button 'Create Restaurant'
      expect(page).to have_content 'pret'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'user cannot leave a review unless logged in' do
      visit '/restaurants'
      click_link 'Add a restaurant'
      expect(page).to have_content'You need to sign in or sign up before continuing.'
    end

    context 'an invalid restaurant' do
      it 'does not let you submit a name that is too short' do
        visit '/restaurants'
        click_link 'Sign up'
        fill_in 'user_email', with: 'loulou@lala.com'
        fill_in 'user_password', with: 'password1245'
        fill_in 'user_password_confirmation', with: 'password1245'
        click_button 'Sign up'
        click_link 'Add a restaurant'
        fill_in 'Name', with: 'kf'
        click_button 'Create Restaurant'
        expect(page).not_to have_content 'kf'
        expect(page).to have_content 'error'
      end
    end
  end

  context 'viewing restaurants' do
    let!(:pret){Restaurant.create(name: 'pret')}

    scenario 'lets a user view a restaurant' do
      visit '/restaurants'
      click_link 'pret'
      expect(page).to have_content 'pret'
      expect(current_path).to eq "/restaurants/#{pret.id}"
    end
  end

  context 'editing restaurants' do
    before { Restaurant.create name: 'pret'}
    scenario 'let a user edit a restaurant' do
      visit '/restaurants'
      click_link 'Sign up'
      fill_in 'user_email', with: 'loulou@lala.com'
      fill_in 'user_password', with: 'password1245'
      fill_in 'user_password_confirmation', with: 'password1245'
      click_button 'Sign up'
      click_link 'Edit pret'
      fill_in 'Name', with: 'pret'
      click_button 'Update Restaurant'
      expect(page).to have_content 'pret'
      expect(current_path).to eq '/restaurants'
    end

    scenario 'user can only edit a restaurant they have created' do
      visit '/restaurants'
      click_link 'Sign up'
      fill_in 'user_email', with: 'loulou@lala.com'
      fill_in 'user_password', with: 'password1245'
      fill_in 'user_password_confirmation', with: 'password1245'
      click_button 'Sign up'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'mini eggs'
      click_button 'Create Restaurant'
      click_link 'Sign out'
      click_link 'Sign up'
      fill_in 'user_email', with: 'sarah@lala.com'
      fill_in 'user_password', with: 'password12345'
      fill_in 'user_password_confirmation', with: 'password12345'
      click_button 'Sign up'
      click_link 'Edit mini eggs'
      click_button 'Update Restaurant'
      expect(page).to have_content 'Unauthorised edit'
    end

  end

  context 'deleting restaurants' do

    scenario 'removes a restaurant when a user clicks a delete link' do
      visit '/restaurants'
      click_link 'Sign up'
      fill_in 'user_email', with: 'loulou@lala.com'
      fill_in 'user_password', with: 'password1245'
      fill_in 'user_password_confirmation', with: 'password1245'
      click_button 'Sign up'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'bob'
      click_button 'Create Restaurant'
      click_link 'Delete bob'
      expect(page).not_to have_content 'bob'
      expect(page).to have_content 'Restaurant deleted successfully'
    end

    scenario 'user can only delete a restaurant they have created' do
      visit '/restaurants'
      click_link 'Sign up'
      fill_in 'user_email', with: 'loulou@lala.com'
      fill_in 'user_password', with: 'password1245'
      fill_in 'user_password_confirmation', with: 'password1245'
      click_button 'Sign up'
      click_link 'Add a restaurant'
      fill_in 'Name', with: 'mini eggs'
      click_button 'Create Restaurant'
      click_link 'Sign out'
      click_link 'Sign up'
      fill_in 'user_email', with: 'sarah@lala.com'
      fill_in 'user_password', with: 'password12345'
      fill_in 'user_password_confirmation', with: 'password12345'
      click_button 'Sign up'
      click_link 'Delete mini eggs'
      expect(page).to have_content 'Cannot delete restaurant you have not added'
    end

  end

end
