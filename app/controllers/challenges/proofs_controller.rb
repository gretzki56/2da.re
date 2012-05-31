class Challenges::ProofsController < ApplicationController

	def create
		id = params[:challenge_id].match(/\d+\w+/).to_s
		@challenge = Challenge.find(id)

		@proof = Proof.new params[:proof]
		@proof.challenge = @challenge
		@proof.user = current_user

		if @proof.valid?
			@proof.save
			
			#TODO:Image ONLY!!!
			@challenge.proofs_count = @challenge.proofs_count+1

			return redirect_to challenge_path(@challenge)
		end

		respond_with(@challenge) do |f|
			f.html{ render "challenges/show" }
		end
	end


	def destroy
		@proof = Proof.find(params[:id])
		if @proof.user == current_user
			@proof.destroy

			challenge = @proof.challenge
			challenge.proofs_count = challenge.proofs_count-1
			challenge.save
		end

		redirect_to challenge_path(@proof.challenge)
	end

end