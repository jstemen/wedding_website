# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :guest do
    first_name "John"
    last_name "Doe"
    email_address {"#{first_name}.#{last_name}@gmail.com"}
  end
end
