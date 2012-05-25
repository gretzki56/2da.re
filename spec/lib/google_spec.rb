require "spec_helper"

describe Google::Maps do

	it "has method #address_to_location" do
		user = build :oto
		Google::Maps.should respond_to :address_to_location

		loc = Google::Maps.address_to_location user.address
		loc.should_not be_nil
		
		loc.keys.include?(:address) == true
		loc.keys.include?(:location) == true
		
		loc[:address] =~ /maribor/i
	end

	it "has method #location_to_address" do
		user = build :oto
		Google::Maps.should respond_to :location_to_address
		add = Google::Maps.location_to_address [46.5573993, 15.645982]
		add.should_not be_nil

		add.keys.include?(:address) == true
		add.keys.include?(:location) == true
		add[:address] =~ /maribor/i
	end

end