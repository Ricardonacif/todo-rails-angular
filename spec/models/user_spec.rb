require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "validations" do

    subject { FactoryGirl.build(:user) }
    
    [:email, :name, :password].each do |attribute|

      it "should not be valid without #{attribute}" do 
        subject.send("#{attribute}=", '')
        expect(subject).not_to be_valid
      end

    end
  end
end