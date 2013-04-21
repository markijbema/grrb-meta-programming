require 'rspec/autorun'

class PersonalData
  def initialize name, email
    @name = name
    @email = email
  end

  attr_accessor :name, :email
end

describe PersonalData do
  it "initializes properly" do
    data = PersonalData.new "Mark", "markijbema@gmail.com"

    expect(data.name).to eq "Mark"
    expect(data.email).to eq "markijbema@gmail.com"
  end

  it 'has properly working setters' do
    data = PersonalData.new nil, nil
    data.name = "Mark"
    data.email = "markijbema@gmail.com"

    expect(data.name).to eq "Mark"
    expect(data.email).to eq "markijbema@gmail.com"
  end
end