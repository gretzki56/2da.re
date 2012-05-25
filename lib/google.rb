require 'json'
require 'net/http'

module Google

	module Maps

		def self.base_url
			"http://maps.googleapis.com/maps/api/geocode/json?sensor=false"
		end

		def self.get_result url
			result = JSON.parse(Net::HTTP.get_response(URI.parse(url)).body)
			raise "Wrong response status code." if result["status"] != "OK"

		   	begin
		   		return result = {
		   			address: result["results"].first["formatted_address"],
					location: result["results"].first["geometry"]["location"].values
				}
		   	rescue
		   		raise "Error while processing results."
		   	end
   		
   			result			
		end

		def self.address_to_location address
			url = URI.encode(address)
			Maps.get_result Maps.base_url+"&address="+url
		end

		def self.location_to_address location
			Maps.get_result Maps.base_url+"&latlng=#{location.first},#{location.last}"
		end

		def address!
			unless location.nil?
				Google::Maps.location_to_address location
			end
		end

		def location!
			unless address.nil?
				Google::Maps.address_to_location address
			end
		end		
	end

end