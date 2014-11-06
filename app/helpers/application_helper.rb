module ApplicationHelper

	def provide_title(page_title)
		base_title = "Harding Computer Science Connect"
		if page_title.empty?
			base_title
		else
			"#{page_title} | #{base_title}"
		end
	end	
end
