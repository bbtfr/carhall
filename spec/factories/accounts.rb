Address = ['搜狐网络大厦', '百度大厦', '北京航空航天大学']

FactoryGirl.define do 
  factory :user, class: Accounts::User do
    mobile { Faker::PhoneNumber.cell_phone }
    password { 'password' }
    username { Faker::Name.name }
    description { Faker::Lorem.sentence }
    detail do
      {
        sex: Accounts::UserDetail::Sex.names.sample,
        area: Share::Area.names.sample,
        brand: Share::Brand.names.sample,
      }
    end
  end

  factory :provider, class: Accounts::Provider do
    mobile { Faker::PhoneNumber.cell_phone }
    password { 'password' }
    username { Faker::Name.name }
    description { Faker::Lorem.sentence }
    detail do
      {
        company: Faker::Lorem.sentence,
        phone: Faker::PhoneNumber.phone_number,
      }
    end
  end

  factory :dealer, class: Accounts::Dealer do
    mobile { Faker::PhoneNumber.cell_phone }
    password { 'password' }
    username { Faker::Name.name }
    description { Faker::Lorem.sentence }
    detail do
      {
        area: Share::Area.names.sample,
        company: Faker::Lorem.sentence,
        address: Address.sample,
        phone: Faker::PhoneNumber.phone_number,
        open_during: Faker::Lorem.sentence,
        dealer_type: Accounts::DealerDetail::DealerType.names.sample,
        specific_service: Accounts::DealerDetail::SpecificService.names.sample,
        business_scopes: Accounts::DealerDetail::BusinessScope.names.sample(3),
        authentication_image: File.open("public/images/thumb/missing.png"),
      }
    end
    location
  end

  factory :location, class: Share::Location do
    latitude { 40 }
    longitude { 116.3 }
  end
end