class User
  include Mongoid::Document
  include Mongoid::Timestamps

  field :fb_uid, type: Integer
  index :fb_uid, unique: true

  field :nickname, type: String
  field :name, type: String
  field :first_name
  field :last_name

  field :token, type: String
  field :locale, type: String

  validates_presence_of :fb_uid
  validates_presence_of :token

  has_many :owned_challenges, inverse_of: "from", class_name: "Challenge"

  def to_s
  	"#{self.name}"
  end

  def to_param
  	"#{self.id}-#{self.to_s}".parameterize
  end

  # Challanges where user is involved
  def challenges
  	Challenge.public.by(self)
  end

  def self.image type=:normal, l_fb_uid=nil
  	"http://graph.facebook.com/#{l_fb_uid}/picture?type=#{type.to_s}"
  end

  # image - from facebook
  def image type=:normal, l_fb_uid=nil #square small normal large
  	l_fb_uid = self.fb_uid if l_fb_uid.nil?
  	"http://graph.facebook.com/#{l_fb_uid}/picture?type=#{type.to_s}"
  end

  def self.from_fb_uid fb_uid
  	User.find(fb_uid: fb_uid)
  end


end
