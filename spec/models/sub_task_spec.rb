require 'rails_helper'

RSpec.describe SubTask, :type => :model do
  context "Validations" do 
    subject { FactoryGirl.build(:sub_task) }

    [:body, :task_id].each do |attribute|

      it "should not be valid without #{attribute}" do 
        subject.send("#{attribute}=", '')
        expect(subject).not_to be_valid
      end
    end

    it "should validate the presence of body" do
      subject.body = ''
      expect(subject).not_to be_valid
    end

  end

  it "" do
    
  end
end