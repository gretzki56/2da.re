class FbUser
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :fb_uid, type: Integer
  field :name, type: String

  def to_s
  	"#{self.name}"
  end

  embedded_in :challenge, inverse_of: "invited_list"
  
end
