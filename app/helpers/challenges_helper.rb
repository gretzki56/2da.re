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

	def has_next=(value=false)
		@has_next ||= value
	end

	def has_next?
		@has_next || false
	end
	
	def has_prev=(value=false)
		@has_prev ||= value
	end

	def has_prev?
		@has_prev || false
	end

	def render_challenges collection
		if collection.empty?
			return content_tag :div, class: "empty_challenges_list" do
				t("empty_challenges_list")
			end
		end

		# return collection.count
		size = collection.count
		@has_next=true if size >= @per_page+1
		@has_prev=true if @page > 0

		# LAST RECORD?
		# render collection
		render collection[0..(@per_page-1)]
		
	end

	def render_challenges_paging
		out = []

		if has_prev?
			out << content_tag(:div, class: "prev") do
				link_to(t("page_prev"), challenges_path(
					:type => @type,
					:mode => @mode,
					:page => @page-1,
					:per_page => @per_page
				),class: "page_prev")
			end
		end

		if has_next?
			out << content_tag(:div, class: "next") do
				link_to(t("page_next"), challenges_path(
					:type => @type,
					:mode => @mode,
					:page => @page+1,
					:per_page => @per_page
				),class: "page_next")
			end
		end

		raw out.join(&:+)
	end
end