# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :sub_task do
    body "MyString"
    task
  end
end
