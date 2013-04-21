require 'rspec/autorun'

class SmartHash < Hash
  def respond_to_missing? method_name, *args
    true
  end

  def method_missing method_name, *args
    self[method_name]
  end
end

describe SmartHash do
  it 'works like a hash' do
    hash = SmartHash.new
    hash[:foo] = 'bar'

    expect(hash[:foo]).to eq 'bar'
  end

  it 'also responds to methods' do
    hash = SmartHash.new
    hash[:foo] = 'bar'

    expect(hash).to respond_to :foo
    expect(hash.foo).to eq 'bar'
  end
end