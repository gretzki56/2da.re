class ChallengeDecorator < Draper::Base
  decorates :challenge

  def deadline_db
    model.deadline
  end

  def deadline_raw
    if model.deadline.present?
      h.content_tag(:div,class:"deadline") do
        h.t(:challenge_deadline,
          deadline: h.distance_of_time_in_words_to_now(model.deadline))
      end
    end
  end

  def deadline
    if model.deadline.present? and model.deadline.to_f-DateTime.now.to_f<2.days.to_f
      deadline_raw
    end
  end

  def perticipants number=5, list_name=:accepted_list
    list, list_out = model.send(list_name.to_s.to_sym), []
    
    list = [ model.invited_list.first ] if list.empty?

    if list.size > number
      list_out << h.content_tag(:div, class: "fb_user more") do
        "+#{list.size-number}"
      end
    end

    list_out = list_out + list.shuffle[1..number].map! do |fb_user|
      h.render(fb_user)
    end

    list_out = list_out.reverse.join("")
    h.content_tag(:div, h.raw(list_out),
      class: "fb_users_list perticipants #{list_name}") 
  end

  def created
    p = [ h.t("created_at", created_at: h.time_ago_in_words(model.created_at)) ]
    p << h.t("updated_at", updated_at: h.time_ago_in_words(model.updated_at)) if model.created_at != model.updated_at
    p.reverse!

    p.map!{|i| h.content_tag(:span,i) }
    h.content_tag(:div, class: "created") do
      h.raw p.join(h.raw("<br/> "))
    end
  end

  def to_s
    model.to_s
  end

  def tools user=nil
    user ||= h.current_user

    if h.signed_in? and (model.can_accept?(user) or model.can_reject?(user) or model.owner?(user))
      h.content_tag :div, class:"challenge_tools" do
        content = []

        if model.can_accept?(user)
          content << h.link_to(h.t("accept"), [challenge,:accept], remote:false, class: "accept")
        end

        if model.can_reject?(user)
           content << h.link_to(h.t("reject"), [challenge,:reject], remote:false, class: "reject")         
        end

        if model.owner?(user)
          content << h.link_to(h.t("edit"), h.edit_challenge_path(challenge))
        end

        h.raw content.join(&:+)
      end
    end
  end



  # Accessing Helpers
  #   You can access any helper via a proxy
  #
  #   Normal Usage: helpers.number_to_currency(2)
  #   Abbreviated : h.number_to_currency(2)
  #
  #   Or, optionally enable "lazy helpers" by including this module:
  #     include Draper::LazyHelpers
  #   Then use the helpers with no proxy:
  #     number_to_currency(2)

  # Defining an Interface
  #   Control access to the wrapped subject's methods using one of the following:
  #
  #   To allow only the listed methods (whitelist):
  #     allows :method1, :method2
  #
  #   To allow everything except the listed methods (blacklist):
  #     denies :method1, :method2

  # Presentation Methods
  #   Define your own instance methods, even overriding accessors
  #   generated by ActiveRecord:
  #
  #   def created_at
  #     h.content_tag :span, time.strftime("%a %m/%d/%y"),
  #                   :class => 'timestamp'
  #   end
end
