class Challenge
  include Mongoid::Document
  include Mongoid::Timestamps

  belongs_to :from, class_name: "User"

  field :to_fb_uids, type: Array

  field :title
  field :description
  field :punishment
  field :reward

  field :deleted, type: Integer, default: 0
  field :for_all, type: Integer, default: 0

  field :status, type: String, default: "created"
  index :status


  field :deadline, type: DateTime

  validates_presence_of :deadline
  validates_presence_of :status
  validates_presence_of :title
  validates_presence_of :from

  validate do |ch|
	ch.must_be_punishment_or_reward
	ch.must_be_in_future
	ch.must_have_to_fb_uids
  end

  def to_s
  	"#{self.title}"
  end

  def to_param
  	"#{self.id}-#{self.title}".parameterize
  end

  # Challenge must have punishment or reward
  def must_be_punishment_or_reward
	if (punishment.nil? or punishment.to_s.strip == "") and
		(reward.nil? or reward.to_s.strip == "")
			errors.add(:base, "Challenge must have punishment and/or reward")
	end  
  end

  # Challange deadline must be set in feature
  def must_be_in_future
	if deadline.nil? || deadline < DateTime.now
		errors.add(:deadline, "Time to complete the challenge must be set in feature!")
  	end
  end

  # Is this challange for everybody?
  def for_all?
  	self.for_all == 1
  end

  # You must set at least one FB user if its not for all
  def must_have_to_fb_uids
  	if not for_all? and (self.to_fb_uids.nil? or self.to_fb_uids.empty?)
  		errors.add(:base,"If the challenge is not for everybody. Then you must set Facebook users.")
  	end
  end

  def created?
  	self.status == "created"
  end

  def accept
  	self.status = "accepted"
  end

  def accepted?
  	self.status == "accepted"
  end

  def reject
  	self.status = "rejected"
  end

  def rejected?
  	self.status == "rejected"
  end

  def answer
  	self.status = "answered"
  end

  def answered?
  	self.status == "answered"
  end

  def complete
  	self.status = "completed"
  end

  def completed?
  	self.status == "completed"
  end

  def fail
  	self.status = "failed"
  end

  def failed?
  	self.status == "failed"
  end

  def to= user
  	if self.to_fb_uids.nil? or self.to_fb_uids.empty?
  		self.to_fb_uids=[user.fb_uid]
  	elsif not(self.to_fb_uids.include? user.fb_uid)
  		self.to_fb_uids << user.fb_uid
  	end
  end

  def to
  	return self.to_fb_uids.first if not(self.to_fb_uids.nil?) and self.to_fb_uids.size == 1
  	return self.to_fb_uids if not(self.to_fb_uids.nil?)
  	return []
  end

  def for_many?
  	not(self.to_fb_uids.nil?) and self.to_fb_uids.size > 1
  end

  # Order by updated_at
  default_scope order_by([:updated_at,:desc])

  # Restrict to user
  scope :by, ->(user){
  	where(:to_fb_uids => user.fb_uid)
  }

  scope :public, where(deleted: 0)
  
  scope :with_status, ->(status_flag) {
  	public.where(status:status_flag.to_s)
  }

  scope :all, ->(){
  	public # 1toN
  }

  scope :accepted, ->(){
  	with_status(:accepted)
  }

end
