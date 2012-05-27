class ChallengesController < ApplicationController


	def index
		@challenges = Challenge.all
	end


	#TODO: Improve!!!
	def show
		begin
			id = params[:id].match(/\d+\w+/).to_s
			@challenge = Challenge.find(id)
		rescue
			flash[:notice] = "Challenge does not exist!"
			return redirect_to root_url
		end
	end

	def new
		@challenge = Challenge.new
		@challenge.from = current_user
		@challenge.deadline = DateTime.now+2.days

=begin
		@challenge.invited_list = [
			User.last.to_fbuser,
			User.last.to_fbuser		
		]
=end
	end

	def create
		@challenge = Challenge.new params[:challenge]
		@challenge.from = current_user

		if @challenge.valid?
			@challenge.save
			flash[:notice]=t("challenge_created")
			return redirect_to challenge_path(@challenge)
		end

		render :edit
	end

end
