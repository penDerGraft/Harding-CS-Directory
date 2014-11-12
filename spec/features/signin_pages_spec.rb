require 'rails_helper'

# RSpec.describe "SigninPages", :type => :request do
#   describe "GET /signin_pages" do
#     it "works! (now write some real specs)" do
#       get signin_pages_index_path
#       expect(response).to have_http_status(200)
#     end
#   end
# end

describe "Authentication" do

	subject { page }

	describe "sign-in page" do
		before { visit signin_path }

	    it { should have_content('Sign in') }
	    it { should have_title('Sign in') }
	end

	describe "sign-in" do
		before { visit signin_path }
		let(:submit) { click_button "Sign in" }

	    describe "with invalid information" do
	    	before { submit }

	    	it { should have_title("Sign in") }
	    	it { should have_selector("div.alert-box.alert") }
	    

		    describe "after visiting a new page" do
		    	before { click_link "Home" }
		    	it { should_not have_selector("div.alert-box.alert")}
		    end
		end

		describe "with vaild information" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email",    with: user.email
				fill_in "Password", with: user.password
				submit
			end


			it { should have_title(user.name) }
			it { should have_link("Profile") }
			it { should have_link("Sign out") }
			it { should_not have_link("Sign in") }

			describe "after signing out" do
				before { click_link('Sign out') }

				it { should have_link ('Sign in') }
				it { should_not have_link ('Sign out') }
			end
		end
	end
end


