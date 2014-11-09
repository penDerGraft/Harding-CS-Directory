module UsersHelper
	def gravatar(user)
		gravatar_hash = Digest::MD5::hexdigest(user.email.squish.downcase)
		gravatar_url = "http://www.gravatar.com/avatar/#{gravatar_hash}"
		image_tag( gravatar_url, alt: "#{user.name} gravatar", class: "left")
	end
end
