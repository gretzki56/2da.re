module ApplicationHelper

	# Login path
	def login_path
		"/auth/facebook"
	end

	# Location for the layou
	def rails_location()
		{ class: "#{controller_name}-#{action_name}", id: "#{controller_name}"}
 	end

 	# Title of the page
	def page_title title= nil
		if title
			content_for(:page_title) { "#{title} - 2da.re" }
			return title
		else
			content_for?(:page_title) ? content_for(:page_title) : "Ready 2da.re?"
		end
	end

	def global?
		params[:region].nil? or params[:region] == "global"
	end

	def local?
		not(params[:region].nil?) and params[:region] == "local"
	end

end
