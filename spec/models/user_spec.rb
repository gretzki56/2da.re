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

			user.should respond_to :location
			user.should respond_to :address
			user.should respond_to :email

			user.should_not be_valid

#			user.should have(1).error_on :token
#			user.should have(1).error_on :fb_uid

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

	context "has Google Maps integration" do
		it "has some conversion stuff" do
			oto = build :oto
			oto.should respond_to :address!
			oto.should respond_to :location!

			oto.location![:address] =~ /maribor/i
		end

		it "brakes on fake address" do
			oto = build :oto
			oto.address = "dsdsdsdsdsdsdsd"

			expect{
				oto.location!.should be_nil
			}.should raise_error 
		end
	end

	context "login user" do
		it "can login" do

			fb_hash = from_json 'facebook_otobrglez.json'
			fb_hash["uid"].should_not be_nil

		end
	end
end
