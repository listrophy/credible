require 'spec_helper'

require 'credible/symmetric_encryption/object_cryptex'

describe Credible::SymmetricEncryption::ObjectCryptex do
  subject { Credible::SymmetricEncryption::ObjectCryptex }

  let(:obj) { Object.new }
  let(:marshalled_obj) { Marshal.dump obj }
  let(:iv) { "fCK1L158ED}b00!3" } # not as random as usual: removed some \xNN chars for brevity
  let(:iv64) { Base64.encode64(iv).strip }
  let(:key) { "A31E1?76fL9YB7J37A88ZHa'B22E4vFC" } # same here
  let(:key64) { Base64.encode64(key).strip }
  let(:encrypted) { 'some encrypted bytes' }
  let(:encrypted64) { Base64.encode64(encrypted).strip }

  let(:arg_checker) { Class.new { def self.check(*args); end } }
  let(:encryption_shim) do
    e, k, i = encrypted, key, iv
    checker = arg_checker
    m = marshalled_obj
    Module.new do
      define_method :encrypt do |*args|
        checker.check *args
        [e, k, i]
      end
      define_method :decrypt do |*args|
        m
      end
    end
  end

  describe '.encrypt' do
    before { subject.extend encryption_shim }

    context 'when passed a base64-encoded key' do
      it 'encrypts the marshaled value to base64' do
        subject.encrypt(obj, key).should == [encrypted64, key64, iv64]
      end
      it 'decodes the key into bytes' do
        subject.should_receive(:de64).with(key64).and_return(key)
        subject.encrypt(obj, key64)
      end
    end
    context 'when not passed a key' do
      it 'encrypts the marshaled value to base64' do
        subject.encrypt(obj).should == [encrypted64, key64, iv64]
      end
      it 'passes an empty key to encrypt' do
        arg_checker.should_receive(:check).with(marshalled_obj, nil).and_return([])
        subject.encrypt(obj)
      end
    end
  end

  describe '.decrypt' do
    it 'decodes the params from base64' do
      Marshal.stub(:load)
      subject.extend(encryption_shim)
      subject.should_receive(:de64).with(encrypted64, key64, iv64).and_return(%w(a b c))
      subject.decrypt(encrypted64, key64, iv64)
    end
    it 'un-marshals the result' do
      Marshal.should_receive(:load).with(marshalled_obj)
      subject.extend(encryption_shim)
      subject.decrypt(encrypted64, key64, iv64)
    end
  end

end
