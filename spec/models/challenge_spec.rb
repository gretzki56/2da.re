require 'spec_helper'

describe Challenge do

	context "some requirements" do
		
		let(:challenge) {
			Challenge.new
		}

		it "has some requirements" do
			challenge.should respond_to :from
			challenge.should respond_to :to=
			challenge.should respond_to :to_fb_uids
			challenge.should respond_to :status

			challenge.should respond_to :title,
				:description, :punishment, :reward, :deadline

			challenge.title = "xxx"
			challenge.to_s.should == "xxx"
			challenge.to_param.should =~ /xxx/

			challenge.status.should == "created"
		end

		it "has validation" do
			challenge = Challenge.new
			
			challenge.should_not be_valid
			challenge.should have(1).error_on :title
			challenge.should have(2).error_on :deadline
			challenge.should have(1).error_on :from

			challenge.should have(2).errors_on :base
			puts challenge.errors.inspect

		end

		it "has some workflow" do
			challenge = build :challenge
			challenge.status == "created"
			
			challenge.should respond_to :accept, :accepted?
			challenge.accept
			challenge.accepted?.should == true
			challenge.status == "accepted"

			challenge.should respond_to :reject, :rejected?
			challenge.reject
			challenge.rejected?.should == true
			challenge.status == "rejected"

			challenge.should respond_to :answer, :answered?
			challenge.answer
			challenge.answered?.should == true
			challenge.status == "answered"

			challenge.should respond_to :complete, :completed?
			challenge.complete
			challenge.completed?.should == true
			challenge.status == "completed"

			challenge.should respond_to :fail, :failed?
			challenge.fail
			challenge.failed?.should == true
			challenge.status == "failed"
		end
	end

end
