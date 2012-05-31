require 'spec_helper'

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
  let(:iv64) { Base64.encode64(iv) }
  let(:key) { "A31E1?76fL9YB7J37A88ZHa'B22E4vFC" } # same here
  let(:key64) { Base64.encode64(key) }
  let(:encrypted) { "Z\x16\x9F\xA5\xF6\x11d\"\xC9.\xDB\xA0Y\x8E\t\xD1\xB09\e~%\xA3\x85\fE\xBB\xE5\xC4\x064J\xB5" }
  let(:encrypted64) { Base64.encode64(encrypted) }

  describe '.encrypt' do
    it 'encrypts the marshaled value to base64' do
      # do some magic stubbing for random_iv
      subject.encrypt(obj, key64).should == [encrypted64, iv]
    end
  end

  describe '.decrypt' do
    it 'decrypts from base64 to a marshaled object' do
      subject.decrypt(encrypted64, key64, iv64).should == obj
    end
  end

  describe '.en64' do
    it 'base64-encodes all the arguments' do
      a, b, c = subject.en64('a', 'b', 'c')
      [a, b, c].should == %w(YQ== Yg== Yw==)
    end
  end

  describe '.de64' do
    it 'base64-decodes all the arguments' do
      a, b, c = subject.de64('YQ==', 'Yg==', 'Yw==')
      [a, b, c].should == %w(a b c)
    end
  end

end
