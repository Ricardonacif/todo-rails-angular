require 'rails_helper'

RSpec.describe Task, :type => :model do
  context "Validations" do 
    subject { FactoryGirl.build(:task) }

    it "should validate the presence of body" do
      subject.body = ''
      expect(subject).not_to be_valid
    end

  end

  it "public should be false by default" do
    expect(subject.public).to be_equal(false)
  end

end