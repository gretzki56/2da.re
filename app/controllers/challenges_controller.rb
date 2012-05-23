class ChallengesController < ApplicationController

	def index
		@challenges = Challenge.all
		render :layout => "beta"
	end

end
