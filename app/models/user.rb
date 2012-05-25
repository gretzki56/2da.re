require "google"

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Google::Maps

  field :fb_uid, type: Integer
  index :fb_uid, unique: true

  field :nickname, type: String
  field :name, type: String
  field :first_name
  field :last_name

  field :address
  field :email

  field :location, type: Array
  index [[ :location, Mongo::GEO2D ]]

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

  def self.to_fbuser user
  	fb_user = FbUser.new({
  		name: user.name,
  		fb_uid: user.fb_uid,
  		created_at: DateTime.now
  	})
  end

  def to_fbuser
  	User.to_fbuser self
  end

  def self.auth h
  	user_new = User.new({
  		fb_uid: h["uid"],
  		name: h["info"]["name"],
  		first_name: h["info"]["first_name"],
  		last_name: h["info"]["last_name"],
  		email: h["info"]["email"],
  		address: h["info"]["location"],
  		token: h["credentials"]["token"],
  		locale: h["info"]["locale"]
  	})

  	existing_user = User.where({fb_uid: user_new.fb_uid}).first
  	if existing_user.nil?
  		if user_new.valid?
  			user_new.save
  			return user_new
  		else
  			return nil
  		end
  	else
  		user = existing_user
  		user.updated_at = DateTime.new
  		user.token = user_new.token
  		user.save
  		return user
  	end

  	return nil
  end


end
