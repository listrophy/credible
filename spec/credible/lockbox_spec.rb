require 'spec_helper'

require 'credible/lockbox'

describe Credible::Lockbox do
  describe '#add_credential_set' do
    it 'adds the set using the name as key' do
      bar = stub(:name => 'foo')
      subject.should_receive(:[]=).with('foo', bar)
      subject.add_credential_set(bar)
    end
  end

  describe '#list' do
    it 'returns a hash of credential_sets, sorted by name' do
      set_a = stub(:name => 'aaa')
      set_b = stub(:name => 'bbb')
      set_c = stub(:name => 'ccc')
      subject.add_credential_set(set_c)
      subject.add_credential_set(set_a)
      subject.add_credential_set(set_b)
      subject.list.should == {'aaa' => set_a, 'bbb' => set_b, 'ccc' => set_c}
    end
  end
end
