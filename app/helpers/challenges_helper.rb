module ChallengesHelper

	def can_accept? user=nil
		@challenge.can_accept?(user || current_user)
	end

	def can_reject? user=nil
		@challenge.can_reject?(user || current_user)
	end

	def owner? user=nil
		user ||= current_user
		@challenge.from == user
	end

	def can_proof? user=nil
		@challenge.can_proof?(user || current_user)
	end

	def challenge_proofs &block
		if @challenge.proofs.size > 0
			content_tag :proofs, yield(block)
		end
	end

	def proof? &block
		user ||= current_user

		if @challenge.can_proof? user
			yield(block)
		end

		#TODO: Add reason why not!!!
	end

end
