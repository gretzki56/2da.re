module UsersHelper

	def fb_image_tag user_or_id, size=:normal, options={}
		path = nil
		#return user_or_id.class
		if user_or_id.class == String || user_or_id.class == Integer || user_or_id.class == Fixnum
			path = User.image size, user_or_id
		elsif user_or_id.class == User
			path = user_or_id.image size
		end

		image_tag(path,options) unless path.nil?
	end

end
