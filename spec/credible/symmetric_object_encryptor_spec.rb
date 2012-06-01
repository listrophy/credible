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
  let(:marshalled_obj) { Marshal.dump obj }
  let(:iv) { "fCK1L158ED}b00!3" } # not as random as usual: removed some \xNN chars for brevity
  let(:iv64) { Base64.encode64(iv).strip }
  let(:key) { "A31E1?76fL9YB7J37A88ZHa'B22E4vFC" } # same here
  let(:key64) { Base64.encode64(key).strip }
  let(:encrypted) do
    case RUBY_VERSION
    when '1.8.7'
      "Z\026\237\245\366\021d\"\311.\333\240Y\216\t\321\333\325\235\006\017\341l\225N\253\336\220\232S\247e"
    else
      "Z\x16\x9F\xA5\xF6\x11d\"\xC9.\xDB\xA0Y\x8E\t\xD1\xB09\e~%\xA3\x85\fE\xBB\xE5\xC4\x064J\xB5"
    end
  end
  let(:encrypted64) { Base64.encode64(encrypted).strip }
  let(:stubbed_aes) do
    stubbed_aes = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
    stubbed_aes.encrypt; stubbed_aes.stub(:encrypt)
    stubbed_aes.iv = iv; stubbed_aes.stub(:random_iv => iv)
    stubbed_aes
  end

  describe '.encrypt' do
    context 'when passed a base64-encoded key' do
      it 'encrypts the marshaled value to base64' do
        subject.stub(:new_cipher => stubbed_aes)
        subject.encrypt(obj, key64).should == [encrypted64, key64, iv64]
      end
    end
    context 'when not passed a key' do
      it 'calls encipher without a key param' do
        subject.should_receive(:encipher).with(marshalled_obj, nil).and_return('')
        subject.encrypt(obj)
      end
    end
  end

  describe '.decrypt' do
    it 'decrypts from base64 to a marshaled object' do
      subject.decrypt(encrypted64, key64, iv64).should == obj
    end
  end

  describe '.encipher' do

    context 'passing a key' do
      it 'returns the cryptext, key and iv' do
        subject.stub(:new_cipher => stubbed_aes)
        subject.encipher(marshalled_obj, key).should == [encrypted, key, iv]
      end
    end

    context 'not passing a key' do
      before { stubbed_aes.key = key }
      it 'calls cipher.random_key' do
        stubbed_aes.should_receive(:random_key).and_return(key)
        subject.stub(:new_cipher => stubbed_aes)
        subject.encipher(marshalled_obj)
      end
      it 'returns the cryptext, (random) key and iv' do
        stubbed_aes.stub(:random_key => key)
        subject.stub(:new_cipher => stubbed_aes)
        subject.encipher(marshalled_obj).should == [encrypted, key, iv]
      end
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
