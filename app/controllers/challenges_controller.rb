class ChallengesController < ApplicationController

	respond_to :html, :json, :js

	def index
		types = %w(all mine)
		type = params[:type] || "all"

		type = types.first unless types.include?(type)
		if type =~ /mine/i
			if params[:mode] =~ /accepted|invited|rejected/
				@challenges = Challenge.all.send Regexp.last_match.to_s.to_sym, current_user
			else
				@challenges = Challenge.all.from current_user
			end
		else
			@challenges = Challenge.all
		end
		
		respond_with(@challenges)
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
