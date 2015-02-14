# Read about factories at https://github.com/thoughtbot/factory_girl


FactoryGirl.define do

  factory :event do
    name { Faker::Lorem.words.join ' ' }
    time { Faker::Time.between(3.months.from_now, 4.months.from_now) }
  end

  # post factory with a `belongs_to` association for the user
  factory :invitation do
    event { create(:event) }
    invitation_group
  end

  factory :invitation_group do
    code {
      Faker::Internet.password
    }
    max_guests 5

    trait :five_guests do
      guests  {
        (1..5).collect{FactoryGirl.create(:guest)}
      }
    end

    trait :four_invitations do
      invitations {
        (1..4).collect{create(:invitation)}
      }
    end


  end

end