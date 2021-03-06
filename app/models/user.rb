class User < ActiveRecord::Base
	before_save { self.email.downcase! }
	before_create :create_auth_token
	validates :name, presence: true, length: { maximum: 40 }
	validates :city, :state, presence: true 
	validates :email, presence: true, length: { maximum: 255 }, 
										format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
										uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }, allow_blank: true
	validates :job_title, :company_or_organization, presence: true, length: { maximum: 255 }
	geocoded_by :address
	after_validation :geocode

	def User.new_auth_token
		SecureRandom.urlsafe_base64
	end

	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	def address
  		[city, state].compact.join(', ')
	end

	def gmaps4rails_infowindow
      link_to user.name, user
    end

	private
		def create_auth_token
			self.auth_token = User.digest(User.new_auth_token)
		end

end
