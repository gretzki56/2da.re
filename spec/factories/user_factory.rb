FactoryGirl.define do
  factory :user, :aliases => [:oto] do
  	fb_uid 1014463747
    nickname "otobrglez"
    name "Oto Brglez"
    first_name "Oto"
    last_name "Brglez"
    token "AAAGPYlQIKkIBAPxZBpeQxZA8QHbAn0OpVJgAjjq3LZBoenQ5AoVrSdHb8s4kts6leEdExEbnsabyyCm1ZAS628l9vQ12EGJniuS5AH3BPgZDZD"
    locale "en_US"
    address "Maribor, Slovenia"
    email "otobrglez@gmail.com"
  end

  factory :jernej, :parent => :user do
    fb_uid 686866884
    nickname "GRETZKi"
    name "Jernej Gracner"
    first_name "Jernej"
    last_name "Gracner"
    locale "en_GB"
    address "Velenje, Slovenia"
    email "oto_brglez_ml@hotmail.com"
  end

  factory :janez, :parent => :user do
    fb_uid 686866883
    nickname "GRETZKi"
    name "Janez Novak"
    first_name "Janez"
    last_name "Novak"
    locale "en_US"
  end 
end