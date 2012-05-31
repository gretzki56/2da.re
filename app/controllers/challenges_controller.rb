class ChallengesController < ApplicationController
	include ActionView::Helpers::DateHelper

	respond_to :html, :json, :js

	before_filter :find_challenge, :only => [
		:edit, :show, :destroy, :update, :accept, :reject]

	def find_challenge
		begin
			f_id = params[:id]
			f_id = params[:challenge_id] if f_id.nil?
			id = f_id.match(/\d+\w+/).to_s
			@challenge = Challenge.find(id)

			if @challenge.deleted?
				flash[:error] = t("challenge_deleted")
				return redirect_to root_url
			end
		rescue
			flash[:error] = t("challenge_missing")
			return redirect_to root_url
		end
	end

	def index
		@types = %w(all mine)
		@type = params[:type] || "all"
		@mode = params[:mode]

		@page = params[:page].to_i <= 0 ? 0 : params[:page].to_i
		@per_page = params[:per_page].to_i <= 0 ? 12 : params[:per_page].to_i

		@type = @types.first unless @types.include?(@type)
		if @type =~ /mine/i
			if @mode =~ /accepted|invited|rejected/
				@challenges = Challenge.all.send Regexp.last_match.to_s.to_sym, current_user
			else
				@challenges = Challenge.all.from current_user
			end
		else
			@challenges = Challenge.all
		end
		
		@challenges = @challenges.page(@page,@per_page)

		@challenges = ChallengeDecorator.decorate(@challenges)
		
		respond_with(@challenges)
	end


	#TODO: Improve!!!
	def show
		@proof = Proof.new(user: current_user)
		@challenge = ChallengeDecorator.new(@challenge)
	end

	def new
		@challenge = Challenge.new(from: current_user,
			deadline: DateTime.now+2.days)
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

	def update
		if @challenge.update_attributes(params[:challenge])
			flash[:notice]=t("challenge_updated")
			@challenge.save
		end

		render :edit
	end

	def edit
	end

	def accept
		if @challenge.accept! current_user
			flash[:notice]=t("challenge_accepted",
				deadline:
					distance_of_time_in_words_to_now(@challenge.deadline))
		end

		return redirect_to challenge_path(@challenge)
	end

	def reject
		if @challenge.reject! current_user
			flash[:notice]=t("challenge_rejected", challenge:@challenge)
		end

		return redirect_to challenge_path(@challenge)
	end
end
