require 'rails_helper'

describe "Static pages" do
	
	subject { page } 
	
  describe "Home page" do
  	before { visit root_path }

    it { should have_selector("div h1", text: "Harding CS Connect") } 

    describe "when user is signed in" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        visit signin_path
        fill_in "Email",    with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
        visit root_path
      end

      it { should have_content(user.name) }
      it { should_not have_selector("div h1", text: "Harding CS Connect") }
    end
  end
  
  describe "About page" do
  	before { visit about_path }
  		
  	it { should have_content('About') }
  end
 
end