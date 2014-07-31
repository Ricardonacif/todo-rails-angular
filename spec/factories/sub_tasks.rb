# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sub_task do
    body "My todo body"
    task
  end
end
