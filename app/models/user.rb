class User < ActiveRecord::Base
	before_save { self.email.downcase! }
	before_create :create_auth_token
	validates :name, presence: true, length: { maximum: 40 }
	validates :city, presence: true 
	validates :email, presence: true, length: { maximum: 255 }, 
										format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i },
										uniqueness: { case_sensitive: false }
	has_secure_password
	validates :password, length: { minimum: 6 }

	def User.new_auth_token
		SecureRandom.urlsafe_base64
	end

	def User.digest(token)
		Digest::SHA1.hexdigest(token.to_s)
	end

	private
		def create_auth_token
			self.auth_token = User.digest(User.new_auth_token)
		end

end
