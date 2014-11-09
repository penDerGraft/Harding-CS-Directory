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
	
	shared_examples_for "all User pages" do
	
		it { should have_title(provide_title(page_title)) }
	end
	
#	describe "Sign-up page" do
#		before { visit signup_path }
#		
#		it { should have_content "Sign up" }
#	end
#	
#	

	describe "Show page" do
		let(:user) { FactoryGirl.create(:user) }
		before { visit user_path(user) }
		
		it { should have_content(user.name) }
		
	end
end
