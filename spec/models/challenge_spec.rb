require 'spec_helper'

describe Challenge do

	context "some requirements" do
		
		let(:challenge) {
			Challenge.new
		}

		it "has some requirements" do
			challenge = Challenge.new
			challenge.should respond_to :from

			challenge.should respond_to :title,
				:description, :punishment, :reward, :deadline,
				:accepted_list, :rejected_list, :invited_list

			challenge.title = "xxx"
			challenge.to_s.should == "xxx"
			challenge.to_param.should =~ /xxx/

		end

		it "has validation" do

			oto = build :oto

			c = Challenge.new
			c.valid?.should == false
			c.errors.include?(:title) == true
			c.errors.include?(:deadline) == true
			c.errors.include?(:from) == true
			c.errors.include?(:base) == true
			
			# 1on1
				c.public=0
				c.should_not be_public
				c.should be_private

				c.should_not be_one_on_one
				# Private
				c.errors.include?(:invited_list) == true

				oto = build :oto
				c.invited_list = [ oto.to_fbuser ]

				c.valid?
				c.should be_one_on_one
				c.errors.include?(:invited_list) == false
		end

	end

	context "Challenge actions" do

		before do
			@oto, @jernej, @janez = build(:oto), build(:jernej), build(:janez)

			@ch_a = build(:lb_challange)
			@ch_a.from= @oto
			@ch_a.invited_list=[@jernej.to_fbuser]
			@ch_a.should be_valid
			@ch_a.public = 1

		end

		it "should be public" do
			@ch_a.should be_public
		end

		it "should be invited" do
			@ch_a.invited?(@jernej).should be_true
		end

		it "should have invite and reject" do
			@ch_a.can_accept?(@jernej).should be_true
			@ch_a.can_reject?(@jernej).should be_false
		end

		it "anyone can accept public" do
			@ch_a.invited?(@janez).should be_false
			@ch_a.can_accept?(@janez).should be_true
			@ch_a.can_reject?(@janez).should be_false
		end

		it "can do nothing if private" do
			@ch_a.public=0
			@ch_a.can_accept?(@janez).should be_false
			@ch_a.can_reject?(@janez).should be_false
			@ch_a.public=1
		end

		it "can do nothing if owner" do
			@ch_a.can_accept?(@oto).should be_false
			@ch_a.can_reject?(@oto).should be_false
		end

		it "can do nothing if expired" do
			@ch_a.can_accept?(@jernej).should be_true
			@ch_a.deadline = 1.days.ago
			@ch_a.can_accept?(@jernej).should be_false
			@ch_a.expired?.should be_true
		end

		it "can #accept! and #reject!" do
			@ch_a.invited_list.to_a.map(&:fb_uid).include?(@jernej.fb_uid).should be_true
			@ch_a.accepted_list.to_a.map(&:fb_uid).include?(@jernej.fb_uid).should be_false
			@ch_a.rejected_list.to_a.map(&:fb_uid).include?(@jernej.fb_uid).should be_false

			@ch_a.accept!(@jernej).should be_true
			@ch_a.accept!(@jernej).should be_false

			@ch_a.can_accept?(@jernej).should be_false
			@ch_a.can_reject?(@jernej).should be_true

			@ch_a.accepted_list.to_a.map(&:fb_uid).include?(@jernej.fb_uid).should be_true
			@ch_a.rejected_list.to_a.map(&:fb_uid).include?(@jernej.fb_uid).should be_false

			@ch_a.reject!(@jernej).should be_true
			@ch_a.reject!(@jernej).should be_false

			@ch_a.rejected_list.to_a.map(&:fb_uid).include?(@jernej.fb_uid).should be_true
			@ch_a.accepted_list.to_a.map(&:fb_uid).include?(@jernej.fb_uid).should be_false
		end

	end

end
