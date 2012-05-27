class UsersController < ApplicationController

	respond_to :html, :json, :js

	def auth_hash; request.env['omniauth.auth'] end

	def auth
		user = User.auth auth_hash
		if user.nil?
			return redirect_to(failure_url) 
		else
			flash[:notice] = "Welcome back #{user}!"
			session[:user_id]=user.id
		end

		redirect_to root_url
	end

	def failure
		#TODO MAKE PRITTY!!!!!
		render :json => {
			status: "Auth failure!"
		}
	end

	def logout
		session[:user_id] = nil # if session.keys.include?(:user_id)
		flash[:notice] = "Bye, bye!"
		redirect_to root_url
	end

	def show
	end


	def fb_friends
		@fb_friends = current_user.fb_friends
		render "fb_users/fb_friends"
	end
end
