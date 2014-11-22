require 'rails_helper'

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

	describe "User index" do
		let(:user) { FactoryGirl.create(:user) }
		before(:each) do
			visit signin_path
			fill_in "Email",    with: user.email
		    fill_in "Password", with: user.password
			click_button "Sign in"
			visit users_path
		end

		it { should have_title("Alumni") }
		it { should have_content("CS Alumni") }

		describe "pagination" do
			before(:all) { 30.times { FactoryGirl.create(:user) } }
			after(:all) { User.delete_all }

			it { should have_selector('ul.pagination') }

			it "should list all users" do
				User.paginate(page: 1).each do |u|
					expect(page).to have_selector("li", text: u.name, 
														text: u.city, 
														text: u.state,
														text: u.job_title,
														text: u.company_or_organization) 
				end	
			end
		end

		describe "searching for a user" do
			let(:search_user) { FactoryGirl.create(:user,   name:  "Find Me",
															email: "findme@domain.com", 
															city:  "A City",
															state: "Arkansas" ) }
			describe "by name" do
				before do 
					fill_in "Search for Alumni",  with: search_user.name
					click_button "Search"
				end

					it "should list the user" do
						expect(page).to have_content(search_user.name)
						expect(page).to have_content(search_user.job_title)
						expect(page).not_to have_content(user.name) 
					end
			end
		end



		describe "delete links" do
			it { should_not have_link("delete") }

			describe "as admin" do
				let(:admin) { FactoryGirl.create(:admin) }
				before do
					visit signin_path
					fill_in "Email",    with: admin.email
				    fill_in "Password", with: admin.password
					click_button "Sign in"
					visit users_path
				end
				
				it { should have_link("delete", href: user_path(User.first)) }
				it "should be able to delete another user" do
					expect do
						click_link("delete", match: :first)
					end.to change(User, :count).by(-1)
				end
				it { should_not have_link("delete", href: user_path(admin)) }
			end

		end
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
				fill_in "Name",       with: "Some name"
				fill_in "Email",      with: "email@domain.com"
				fill_in "City",       with: "Some City"
				select  "Texas",      from: "State"
				fill_in "Job Title",  with: "Some Job"
				fill_in "Company/Organization", with: "Some company"
				fill_in "Password",   with: "foobar"
				fill_in "Password Confirmation", with: "foobar"
			end
				
			it "should create a user" do 
				expect { click_button submit }.to change(User, :count).by(1)
			end
			
			describe "after user is saved" do
					before { click_button submit }
					
					it { should have_selector('div.alert-box.success') }
					it { should have_link('Sign out') }
					it { should_not have_link('Sign in') }
			end
		
		end		
	end 

	describe "updating user" do
		let(:user) { FactoryGirl.create(:user) }
		before do
			visit signin_path
			fill_in "Email",    with: user.email
			fill_in "Password", with: user.password
			click_button "Sign in"
			visit edit_user_path(user)
		end

		it { should have_content('Update Your Information') }
		it { should have_title('Edit user') }
		it { should have_link('change') }


		describe "with valid information" do
			let(:new_name) { "New name" }
			let(:new_email) { "newemail@domain.com" }
			let(:new_city) { "New city" }
			let(:new_state) { "Arkansas" }
			before do
				fill_in "Name",     with: new_name
				fill_in "Email",    with: new_email
				fill_in "City",     with: new_city
				select new_state,   :from => "State"
				click_button "Update User"
			end

			it { should have_title(new_name) }
			it { should have_selector('div.alert-box.success') }
			it { should have_link("Sign out", href: signout_path) }
			specify { expect(user.reload.name).to  eq new_name }
			specify { expect(user.reload.email).to eq new_email }
			specify { expect(user.reload.city).to eq new_city }
		end
	end
end


