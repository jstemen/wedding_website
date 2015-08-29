# Read about factories at https://github.com/thoughtbot/factory_girl


FactoryGirl.define do

  factory :event do
    name { Faker::Lorem.words.join ' ' }
    time { Faker::Time.between(3.months.from_now, 4.months.from_now) }
    address { Faker::Address }
  end

  # post factory with a `belongs_to` association for the user
  factory :invitation do
    is_accepted false
    event { create(:event) }
    invitation_group {create(:invitation_group)}

    trait :with_guest do
      after(:build) do |invitation, evaluator|
        create(:guest, invitations: [invitation])
      end
    end
  end

  factory :invitation_group do
    code {
      Faker::Internet.password.upcase
    }

    transient do
      with_accepted_invitations false
    end

    is_confirmed false

    trait :five_guests do
      after(:build) do |invitation_group, evaluator|
        create_list(:invitation, 5, :with_guest, invitation_group: invitation_group, is_accepted: evaluator.with_accepted_invitations)
      end
    end


    trait :four_invitations do
      after(:build) do |invitation_group, evaluator|
        create_list(:invitation, 4, :with_guest, invitation_group: invitation_group, is_accepted: evaluator.with_accepted_invitations)
      end
    end


  end

end
