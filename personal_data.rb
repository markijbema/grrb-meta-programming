require 'rspec/autorun'

module Attributes
  def attribute *attributes
    attributes.each do | attribute |
      module_eval <<-end_of_defs
        def #{attribute}
          @#{attribute}
        end
        def #{attribute}= val
          @#{attribute} = val
        end
      end_of_defs
    end
  end
end

class PersonalData
  extend Attributes

  def initialize name, email
    @name = name
    @email = email
  end

  attribute :name, :email
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