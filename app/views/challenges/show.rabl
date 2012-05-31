object @challenge

attributes :title, :description, :punishment, :reward
attributes :public, :deleted
attribute :deadline_db
attribute :deadline

child(:from => :from) do |f|
	attributes :name, :id, :fb_uid
end

node :invited_list do
	partial("fb_users/fb_user", :object => @challenge.invited_list)
end

node :accepted_list do
	partial("fb_users/fb_user", :object => @challenge.accepted_list)
end

node :rejected_list do
	partial("fb_users/fb_user", :object => @challenge.rejected_list)
end

child :proofs do
	attributes :id, :photo, :comment, :created_at
end
