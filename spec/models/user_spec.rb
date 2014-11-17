require 'rails_helper'

describe User do
	
	before do
		@user = User.new(name: "Some User", email: "someuser@somedomain.com", city: "somecity", state: "ST", 
							job_title: "some job", company_or_organization: "some company", password: "somepassword", 
																				password_confirmation: "somepassword")
	end
	
	subject { @user }

	# Test each attribute using respond_to? method
	it { should respond_to(:name)  }
	it { should respond_to(:email) }
	it { should respond_to(:city)  }
	it { should respond_to(:state) }
	it { should respond_to(:job_title) }	
	it { should respond_to(:company_or_organization) }
	it { should respond_to(:password_digest) }
	it { should respond_to(:password) }
	it { should respond_to(:password_confirmation) }
	it { should respond_to(:auth_token) }
	it { should respond_to(:admin) }
	it { should respond_to(:authenticate) }

	it { should be_valid}
	it { should_not be_admin }

	describe "with admin attribute" do
		before do
			@user.save!
			@user.toggle!(:admin)
		end
		
		it { should be_admin }	
	end
		
	describe "when name is blank" do
		before { @user.name = ' ' }
		it { should_not be_valid}
	end
	
	describe "when city is blank" do
		before { @user.city = ' ' }
		it { should_not be_valid}
	end
	
	describe "when email is blank" do
		before { @user.email = ' ' }
		it { should_not be_valid}
	end

	describe "when state is blank" do
		before { @user.state = ' ' }
		it { should_not be_valid}
	end

	describe "when job title is blank" do
		before { @user.job_title = ' ' }
		it { should_not be_valid}
	end

	describe "when company is blank" do
		before { @user.company_or_organization = ' ' }
		it { should_not be_valid}
	end

	describe "when name is too long" do
		before { @user.name = 'a' * 41 }
		it { should_not be_valid}
	end
	
	describe "when email is too long" do
		before { @user.email = 'a' * 256 }
		it { should_not be_valid}
	end

	describe "when job title is too long" do
		before { @user.job_title = 'a' * 256 }
		it { should_not be_valid}
	end

	describe "when company/organization is too long" do
		before { @user.company_or_organization = 'a' * 256 }
		it { should_not be_valid}
	end
	
	describe "when password is too short" do
		#double assignment
		before { @user.password = @user.password_confirmation = 'a' * 5 }
		it { should_not be_valid }
	end
	
	#make sure that regex does not exclude valid e-mails
	describe "when email format is valid" do
		it "should be valid" do
			valid_addresses = %w[user@domain.com USER@domain.us s_oMe__USer@DOM.AIN.org first.last@domain.net]
			
			valid_addresses.each do |address|
				@user.email = address
				expect(@user).to be_valid
			end
		end
	end
	
	describe "when email format is not valid" do
		it "should not be valid" do
			invalid_addresses = %w[user@domain,com USER_at_domain.us s_oMe__USer@DOM_AIN.org first.last@domain.]
			
			invalid_addresses.each do |address|
				@user.email = address
				expect(@user).not_to be_valid
			end
		end
	end
	
	describe "when email is already taken" do 
		before do
			same_user = @user.dup
			same_user.email = @user.email.upcase
			same_user.save
		end
		
		it { should_not be_valid}
	end

	describe "authenticity token" do
		before { @user.save }

		it { expect(@user.auth_token).not_to be_blank }
	end

			
end
