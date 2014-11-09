require 'rails_helper'

#RSpec.describe "UserPages", :type => :request do
#  describe "GET /user_pages" do
#    it "works! (now write some real specs)" do
#      get user_pages_index_path
#      expect(response).to have_http_status(200)
#    end
#  end
#end

describe "User pages" do
	
	subject { page }
	
	shared_examples_for "all user pages" do
	
		it { should have_title(provide_title(page_title)) }
	end
	
	describe "Sign-up page" do
		before { visit signup_path }
		
		it { should have_content "Sign up" }
	end
	
	describe "Show page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }
		
		it { should have_content(user.name) }
		
	end
	
	describe "sign up" do
		
		before { visit signup_path }
		
		let(:submit) { "Create User" }
		
		describe "when submission is invalid" do
			it "should not create a user" do
				expect { click_button submit }.not_to change(User, :count)
			end
		end
		
		describe "when submission is valid" do
			before do
				fill_in "Name",     with: "Some name"
				fill_in "Email",    with: "email@domain.com"
				fill_in "City",     with: "Some City"
				fill_in "Password", with: "foobar"
				fill_in "Password Confirmation", with: "foobar"
			end
				
			it "should create a user" do 
				expect { click_button submit }.to change(User, :count).by(1)
			end
			
			describe "after user is saved" do
					before { click_button submit }
					
					it { should have_selector('div.alert-box.success') }
			end
		
		end		
	end 
end


