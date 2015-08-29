# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :guest do
    first_name {Faker::Name.first_name}
    last_name {Faker::Name.last_name}
    email_address {"#{first_name}#{last_name}@mailinator.com"}
    trait :bad_email do
      email_address "123fake"
    end

    trait :no_email do
      email_address ''
    end
  end
end
