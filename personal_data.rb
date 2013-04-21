require 'rspec/autorun'

class PersonalData
  def initialize name, email
    @name = name
    @email = email
  end

  def name
    @name
  end
  def name= name
    @name = name
  end

  def email
    @email
  end
  def email= email
    @email = email
  end


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