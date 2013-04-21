require 'rspec/autorun'
require "digest/md5"

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

  def memoize *methods
    prepend Memoized(*methods)
  end
end

def Memoized *methods
  Module.new do
    methods.each do |method|
      module_eval <<-end_of_defs
        def #{method}
          @_memoized_value_for_#{method} ||= super
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

  def gravatar_url
    gravatar_hash = Digest::MD5.hexdigest(email)
    "http://www.gravatar.com/avatar.php?gravatar_id=#{gravatar_hash}"
  end

  def email_link
    "<a href=\"mailto:#{email}\">#{name}</a>"
  end

  memoize :gravatar_url, :email_link
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

  it 'returns the gravatar url' do
    data = PersonalData.new "Mark", "markijbema@gmail.com"

    expect(data.gravatar_url).to eq "http://www.gravatar.com/avatar.php?gravatar_id=86f77339c385c35c7bac770b2e3921c2"
  end

  it 'returns the gravatar url twice' do
    data = PersonalData.new "Mark", "markijbema@gmail.com"


    hash = Digest::MD5.hexdigest('markijbema@gmail.com')
    Digest::MD5.should_receive(:hexdigest).once.and_return(hash)

    expect(data.gravatar_url).to eq "http://www.gravatar.com/avatar.php?gravatar_id=86f77339c385c35c7bac770b2e3921c2"
    expect(data.gravatar_url).to eq "http://www.gravatar.com/avatar.php?gravatar_id=86f77339c385c35c7bac770b2e3921c2"
  end

  it 'returns the email_link' do
    data = PersonalData.new "Mark", "markijbema@gmail.com"

    expect(data.email_link).to eq "<a href=\"mailto:markijbema@gmail.com\">Mark</a>"
  end

  it 'returns the email_link twice' do
    data = PersonalData.new "Mark", "markijbema@gmail.com"

    expect(data.email_link).to eq "<a href=\"mailto:markijbema@gmail.com\">Mark</a>"
    expect(data.email_link).to eq "<a href=\"mailto:markijbema@gmail.com\">Mark</a>"
  end

  it 'does not contain more methods than needed' do
    data = PersonalData.new "Mark", "markijbema@gmail.com"

    specific_methods = data.methods - Object.new.methods
    expect(specific_methods).to match_array  [:name, :name=, :email, :email=, :gravatar_url, :email_link]

  end
end