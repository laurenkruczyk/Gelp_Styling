require 'spec_helper'

feature 'user edit review', %Q{
As a user
I want to be able to edit my review
So i can update my thoughts on the review
} do

#Acceptance Criteria
#A User can edit a review that he/she created
before :each do
    @ruby_gem = FactoryGirl.create(:ruby_gem)
    @user = FactoryGirl.create(:user)
end


context 'user edits own review' do
  before :each do
    @review = FactoryGirl.create(:review, user: @user, ruby_gem: @ruby_gem)
    sign_in_as(@user)
    visit ruby_gems_path
    click_on @ruby_gem.name
    click_on 'Edit Review'
  end

   scenario 'signed in user edits their review' do
      fill_in 'Title', with: @review.title
      fill_in 'Body', with: @review.body
      select @review.rating, from: 'Rating'
      click_on 'Update Review'

      expect(page).to have_content("Review Successfully Updated")
      expect(current_path).to eql(ruby_gem_path(@ruby_gem))
      expect(Review.first.body).to eql('review here')
   end

   scenario 'authenticated user does not provide required fields to edit review' do

      fill_in 'Title', with: ""
      fill_in 'Body', with: ""
      select '5', from: 'Rating'
      click_on 'Update Review'

      expect(page).to_not have_content("Review Successfully Updated")
      expect(@review.title).to eql("Ruby Gem")
   end
end

 scenario 'signed in user cannot edit review that he has not created' do
    review = FactoryGirl.create(:review, user_id: 5, ruby_gem: @ruby_gem)
    sign_in_as(@user)
    visit ruby_gems_path
    click_on @ruby_gem.name

    expect(page).to_not have_content('Edit Review')
 end

end
