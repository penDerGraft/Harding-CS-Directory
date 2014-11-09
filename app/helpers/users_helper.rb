module UsersHelper
	def gravatar(user)
		gravatar_hash = Digest::MD5::hexdigest(user.email.squish.downcase)
		gravatar_url = "http://www.gravatar.com/avatar/#{gravatar_hash}"
		#ruby implicit return - returns last statement evaluated
		image_tag( gravatar_url, alt: "#{user.name} gravatar", class: "gravatar")
	end
end
