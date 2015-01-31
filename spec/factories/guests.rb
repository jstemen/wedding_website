# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :guest do
    first_name "MyString"
    last_name "MyString"
    email_address "MyString"
  end
end
