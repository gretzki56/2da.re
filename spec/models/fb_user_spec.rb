require 'spec_helper'

describe FbUser do

	let(:fb_user){
		FbUser.new
	}

	it "has some fields" do
		fb_user.should respond_to :fb_uid, :name, :created_at
	end

end
