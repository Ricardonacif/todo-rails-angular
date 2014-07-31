require 'rails_helper'


RSpec.describe ApplicationHelper, :type => :helper do
  it "should return the correct flash_class of twitter bootstrap alert" do 
    expect(flash_class('notice')).to include("alert alert-info")
    expect(flash_class('success')).to include("alert alert-success")
    expect(flash_class('error')).to include("alert alert-danger")
    expect(flash_class('alert')).to include("alert alert-warning")
  end
end
