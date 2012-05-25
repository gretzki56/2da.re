class UsersController < ApplicationController

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
		session[:user_id] = nil if session.keys.include?(:user_id)
		redirect_to root_url
	end

end
