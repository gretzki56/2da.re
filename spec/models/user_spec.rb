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

	context "user can create challenge" do

		let(:oto){ build :oto }
		let(:jernej){ build :jernej}
		let(:janez){ build :janez}
		let(:ch_A){ build :lb_challange}
		let(:ch_B){ build :power_slide_challange}

		before :each do
		end

		it "has fb image" do
			oto.should respond_to :image
			oto.image.should =~ /graph/
		end

		it "can create new challenge" do
			ch_A.from = oto
			ch_A.to= jernej
			ch_A.to= janez
	
			ch_A.to_fb_uids.size.should == 2

			ch_B.from = jernej
			ch_B.to = oto

			ch_A.should be_created
			ch_A.should be_valid
			ch_B.should be_created
			ch_B.should be_valid

			ch_A.accept
			ch_B.reject

			ch_A.should be_accepted
			ch_B.should be_rejected

			[ch_A,ch_B].map(&:save)

			ch_A_f = oto.owned_challenges.accepted.first
			ch_A_f.should == ch_A

			chl = oto.challenges.first
			chl.should == ch_B
		end

	end

end
