require 'spec_helper'

describe User do

	context "user has some requirements" do
		let(:user) {
			User.new
		}

		it "has requirements" do
			user.should respond_to :fb_uid, :nickname, :name, :first_name, :last_name, :token, :locale
			user.should respond_to :created_at, :updated_at
			user.should respond_to :to_s
			#user.should respond_to :challenges

			user.should_not be_valid

			user.should have(1).error_on :token
			user.should have(1).error_on :fb_uid

			user.name = "Oto Brglez"
			user.to_s.should =~ /Oto/
			user.to_param.should =~ /Brglez/i
		end
	end

	context "convert to user" do

		it "can be converted" do

			oto = build :oto
			oto.should respond_to :to_fbuser

			fb_user = oto.to_fbuser
			fb_user.class.should == FbUser

			fb_user.name.should == oto.name
			fb_user.fb_uid.should == oto.fb_uid
			fb_user.created_at.should_not be_nil

		end

	end
end
