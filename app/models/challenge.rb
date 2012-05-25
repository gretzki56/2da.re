class Challenge
  include Mongoid::Document
  include Mongoid::Timestamps



  field :title
  field :description
  field :punishment
  field :reward

  field :public, type: Integer, default: 0
  field :deleted, type: Integer, default: 0
  field :deadline, type: DateTime

  validates_presence_of :from
  validates_presence_of :title
  validates_presence_of :deadline

  belongs_to :from, class_name: "User"

  embeds_many :invited_list, class_name: "User"
  embeds_many :accepted_list, class_name: "User"
  embeds_many :rejected_list, class_name: "User"


  validate do |ch|
  	ch.must_have_users_if_private
	ch.must_be_punishment_or_reward
	ch.must_be_in_future
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

  def must_have_users_if_private
  	if private? and (invited_list.nil? || invited_list.empty?)
  		errors.add(:invited_list, "You must invite friends to your private challenge!")
  	end
  end

  # You must set at least one FB user if its not for all
  def must_have_to_fb_uids
  	if not(for_all?) and (self.to_fb_uids.nil? or self.to_fb_uids.empty?)
  		errors.add(:base,"If the challenge is not for everybody. Then you must set Facebook users.")
  	end
  end

  def public?
  	self.public == 1
  end

  def private?
  	not public?
  end

  def one_on_one?
  	not(invited_list.nil?) and invited_list.size == 1
  end



=begin

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
=end

end
