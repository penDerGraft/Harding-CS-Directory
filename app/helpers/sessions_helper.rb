module SessionsHelper
	def sign_in(user)
		auth_token = User.new_auth_token
		cookies.permanent[:auth_token] = auth_token
		# send hashed token to db
		user.update_attribute(:auth_token, User.digest(auth_token))
		self.current_user = user
	end

	# ruby assignment method
	def current_user=(user)
		@current_user = user
	end

	def current_user
		auth_token = User.digest(cookies[:auth_token])
		@current_user ||= User.find_by(auth_token: auth_token)
	end

	def signed_in?
		!current_user.nil?
	end

	def sign_out
		current_user.update_attribute(:auth_token, User.digest(User.new_auth_token))
		cookies.delete(:auth_token)
		self.current_user = nil
	end
end
