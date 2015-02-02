# Read about factories at https://github.com/thoughtbot/factory_girl


FactoryGirl.define do

  factory :event do
    name "wedding"
    time "2015-01-31 13:06:43"
  end
  
  # post factory with a `belongs_to` association for the user
  factory :invitation do
    event
    invitation_group

  end

  factory :invitation_group do
    code "MyString"
    max_guests 2
    factory :invitation_group_with_invitations do
      # posts_count is declared as a transient attribute and available in
      # attributes on the factory, as well as the callback via the evaluator
=begin
      transient do
        invitations_count 5
      end
=end

      # the after(:create) yields two values; the user instance itself and the
      # evaluator, which stores all values from the factory, including transient
      # attributes; `create_list`'s second argument is the number of records
      # to create and we make sure the user is associated properly to the post
      after(:create) do |invitation_group, evaluator|
        create_list(:invitation, 5, invitation: invitation)
      end
    end
    
  end

end