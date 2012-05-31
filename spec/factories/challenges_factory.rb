FactoryGirl.define do
  
  factory :challenge, :aliases => [:lb_challange] do
  	association :from, factory: :oto
  	title "Longboarding challange: Coleman slide"
  	description "Master the coleman slide till the end of the week."
  	reward "Free beer"
    deadline DateTime.now+2.days
  end

   factory :power_slide_challange, :parent => :challenge  do
  	association :from, factory: :jernej
  	association :to, factory: :oto
  	title "Longboarding challange: Power slide"
  	description "Do the fast power slide till the end of the year"
  	reward "Free beer"
    deadline DateTime.now+2.days
  end 


end