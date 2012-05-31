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
  field :proofs_count, type: Integer, default: 0

  validates_presence_of :from
  validates_presence_of :title
  validates_presence_of :deadline

  belongs_to :from, class_name: "User"

  embeds_many :invited_list, class_name: "FbUser"
  embeds_many :accepted_list, class_name: "FbUser"
  embeds_many :rejected_list, class_name: "FbUser"

  has_many :proofs

  accepts_nested_attributes_for :invited_list
  accepts_nested_attributes_for :accepted_list

  attr_accessor :friend_search

  validate do |ch|
    # ch.must_not_invite_himself
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
		errors.add(:deadline, "must be set in feature")
  	end
  end

  def must_have_users_if_private
  	if private? and (invited_list.nil? || invited_list.empty?)
  		errors.add(:invited_list, "must include at least one your friends")
  	end
  end

  def must_not_invite_himself
    if not(invited_list.nil?) and not(invited_list.empty?)
      in_invlist = invited_list.where({fb_uid:fb_uid}).first
      unless in_invlist.nil?
        errors.add(:invited_list,"You can't invite yourself!")
      end
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

  default_scope order_by([:updated_at,:desc])

  scope :public, where(deleted: 0)

  scope :all, ->(){
    public
  }
  scope :page, ->(page=1, per_page=12){
    page=0 if page < 0 # Start at page=1

    per_page = per_page + 1 # check!
    skip = (page*per_page)-page
    skip = 0 if skip < 0
    limit(per_page).skip(skip)
  }

  # Find all challenges where user is involved
  scope :from, ->(user){
    if user.class == User
      any_of({ from_id: user.id },
        {:"invited_list.fb_uid" => user.fb_uid},
        {:"accepted_list.fb_uid" => user.fb_uid},
        {:"rejected_list.fb_uid" => user.fb_uid}
      )
    elsif user.class == FbUser
      any_of(
        {:"invited_list.fb_uid" => user.fb_uid},
        {:"accepted_list.fb_uid" => user.fb_uid},
        {:"rejected_list.fb_uid" => user.fb_uid}
      )
    end
  }

  scope :accepted, ->(user){
    any_of(
        {:"accepted_list.fb_uid" => user.fb_uid}
      )
  }

  scope :invited, ->(user){
    any_of(
        {:"invited_list.fb_uid" => user.fb_uid}
      )
  }

  scope :rejected, ->(user){
    any_of(
        {:"rejected_list.fb_uid" => user.fb_uid}
    )    
  }

  def invited? user
    #invited_list.where(:"fb_uid"=>user.fb_uid).first
    invited_list.to_a.map(&:fb_uid).include? user.fb_uid
  end

  def rejected? user
    #rejected_list.where(:"fb_uid"=>user.fb_uid).first
    rejected_list.to_a.map(&:fb_uid).include? user.fb_uid
  end

  def accepted? user
    #accepted_list.where(:"fb_uid"=>user.fb_uid).first
    accepted_list.to_a.map(&:fb_uid).include? user.fb_uid
  end

  def owner? user
    from == user
  end

  def can_accept? user
    return false if expired? or owner?(user)

    if public?
      not(accepted?(user))
    elsif private?
      if invited?(user)
        not(accepted?(user))
      else
        false
      end
    else
      false
    end
  end

  def can_reject? user
    return false if expired? or owner? user

    if public?
      accepted?(user)
    elsif private?
      if invited?(user)
        not(rejected?(user))
      else
        false
      end
    else
      false
    end
  end

  def accept! user
    if can_accept? user
      fb_user = user.to_fbuser
      fb_user.created_at = DateTime.now

      rejected_list.destroy_all(fb_uid: fb_user.fb_uid)
      accepted_list << fb_user
      save
    end
  end

  def reject! user
    if can_reject? user
      fb_user = user.to_fbuser
      fb_user.created_at = DateTime.now

      accepted_list.destroy_all(fb_uid: fb_user.fb_uid)
      rejected_list << fb_user
      save
    end
  end

  def can_proof? user
    accepted?(user) or from==user
  end

  def one_on_one?
    not(public?) and (
      not(invited_list.nil?) and invited_list.size == 1)
  end

  def expired?
    DateTime.strptime(deadline.to_s) < DateTime.now
  end

  def has_image_proofs?
    proofs.where(:"photo.ne" => nil).last
  end

  def statuses
    out = []

    out << :expired if expired?
    out << :ongoing if not(expired?)
    out << :public if public?
    out << :private if not(public?)
    out << :one_on_one if one_on_one?
    out << :with_proofs if has_image_proofs?

    out
  end

  def possible_actions

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
