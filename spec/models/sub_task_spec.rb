require 'rails_helper'

RSpec.describe SubTask, :type => :model do
  context "Validations" do 
    subject { FactoryGirl.build(:task) }

    it "should validate the presence of body" do
      subject.body = ''
      expect(subject).not_to be_valid
    end

  end

end
