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

end
