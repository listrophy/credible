require 'spec_helper'
require 'pry'

require 'credible/symmetric_object_encryptor'

class FakeLockbox
  attr_accessor :r
  def initialize;     self.r = 'foo';    end
  def marshal_dump;   self.r;            end
  def marshal_load x; self.r = x;        end
  def == other;       self.r == other.r; end
end

describe Credible::SymmetricObjectEncryptor do
  subject { Credible::SymmetricObjectEncryptor }

  let(:obj) { FakeLockbox.new }
  let(:iv) { "fCK1L158ED}b00!3" } # not as random as usual: removed some \xNN chars for brevity
  let(:key) { "A31E1?76fL9YB7J37A88ZHa'B22E4vFC" } # same here
  let(:encrypted) { "WhafpfYRZCLJLtugWY4J0bA5G34lo4UMRbvlxAY0SrU=" }

  describe '.encrypt' do
    it 'encrypts the marshaled value to base64' do
      subject.encrypt(obj, key, iv).should == [encrypted, iv]
    end
  end

  describe '.decrypt' do
    it 'decryptes from base64 to a marshaled object' do
      subject.decrypt(encrypted, key, iv).should == obj
    end
  end

end
