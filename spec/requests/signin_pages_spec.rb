require 'rails_helper'

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
		    	before { click_link("Home", match: :first) }
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
			it { should have_link("Profile", users_path(user)) }
			it { should have_link("Sign out", href: signout_path) }
			it { should have_link("Update Info", href: edit_user_path(user)) }
			it { should have_link("Find Alumni", href: users_path) }
			it { should_not have_link("Sign in", href: signin_path) }

			describe "after signing out" do
				before { click_link('Sign out', match: :first) }

				it { should have_link ('Sign in') }
				it { should_not have_link ('Sign out') }
			end
		end
	end

	describe "authorization" do 

		describe "when user is not signed in" do
			let(:user) { FactoryGirl.create(:user) }

			describe "trying to access protected page" do
				before { visit edit_user_path(user) }
				it { should have_title("Sign in") }

				describe "after signing in" do
					before do
						fill_in "Email",    with: user.email
		        		fill_in "Password", with: user.password
				        click_button "Sign in"
				    end

				    it "should render the desired page" do
				    	expect(page).to have_title('Edit user')
				   	end
				end
			end


			describe "trying to update data" do
				before { patch user_path(user) }
				specify { expect(response).to redirect_to(signin_path) }
			end

			describe "accessing the users index" do
				before { visit users_path }

				it { should have_title('Sign in') }
				it { should_not have_title('Alumni') }
			end
		end

		describe "wrong user" do 
			let(:user) { FactoryGirl.create(:user) }
			let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@domain.com") }
			before do
				auth_token = User.new_auth_token
			    cookies[:auth_token] = auth_token
			    user.update_attribute(:auth_token, User.digest(auth_token))
			end

			describe "when accessing another user's edit page" do
				before { get edit_user_path(wrong_user) }

				specify { expect(response.body).not_to match(provide_title("Edit user")) }
				specify { expect(response).to redirect_to(root_url) }
			end

			describe "when trying to submit a patch request" do
				before { patch user_path(wrong_user) }

				specify { expect(response).to redirect_to(root_url) }
			end
		end

		describe "as regular user" do
			let(:user) { FactoryGirl.create(:user) }
			let(:non_admin) { FactoryGirl.create(:user) }

			before do
				auth_token = User.new_auth_token
			    cookies[:auth_token] = auth_token
			    non_admin.update_attribute(:auth_token, User.digest(auth_token))
			end

			describe "trying to delete a user" do
				before { delete user_path(user) }
				specify { expect(response).to redirect_to(root_url) }
      	  end
    	end
	end	
end


