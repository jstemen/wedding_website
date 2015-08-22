# Read about factories at https://github.com/thoughtbot/factory_girl


FactoryGirl.define do

  factory :event do
    name { Faker::Lorem.words.join ' ' }
    time { Faker::Time.between(3.months.from_now, 4.months.from_now) }
    address { Faker::Address}
  end

  # post factory with a `belongs_to` association for the user
  factory :invitation do
    event { create(:event) }
    #todo make this stop gernerating blank igs
    invitation_group
    trait :with_guest do
      guest {create(:guest)}
    end
  end

  factory :invitation_group do
    code {
      Faker::Internet.password.upcase
    }
    is_confirmed false

    trait :five_guests do
      invitations  {
        (1..5).collect{FactoryGirl.create(:invitation, :with_guest)}
      }
    end

    trait :four_invitations do
      invitations {
        (1..4).collect{FactoryGirl.create(:invitation)}
      }
    end


  end

end
