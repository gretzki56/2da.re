class FbUser
  include Mongoid::Document
  include Mongoid::Timestamps::Created

  field :fb_uid, type: Integer
  field :name, type: String

  def to_s
  	"#{self.name}"
  end

  def image type=:normal, l_fb_uid=nil #square small normal large
  	l_fb_uid = self.fb_uid if l_fb_uid.nil?
  	"http://graph.facebook.com/#{l_fb_uid}/picture?type=#{type.to_s}"
  end

  embedded_in :challenge, inverse_of: "invited_list"
  
end
