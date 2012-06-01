require 'spec_helper'

require 'credible/symmetric_encryption/cryptex'

describe Credible::SymmetricEncryption::Cryptex do
  subject { Credible::SymmetricEncryption::Cryptex }

  let(:str) { 'this is my >16 char string' }
  let(:iv) { "fCK1L158ED}b00!3" } # not as random as usual: removed some \xNN chars for brevity
  let(:key) { "A31E1?76fL9YB7J37A88ZHa'B22E4vFC" } # same here
  let(:encrypted) { "Tq\x00\x89\xFD\xDE\xD6\xB9\xD6G\x98J\x9D\x1E\x8E\x06\x02C\x11\xC7\xDB(\x89\xCFp\xC0\xB9\xC7\x05H?r" }

  let(:stubbed_aes) do
    stubbed_aes = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
    stubbed_aes.encrypt; stubbed_aes.stub(:encrypt)
    stubbed_aes.iv = iv; stubbed_aes.stub(:random_iv => iv)
    stubbed_aes
  end

  describe '.encrypt' do

    context 'when passed a key' do
      it 'encrypts the value using the key' do
        subject.stub(:new_cipher => stubbed_aes)
        subject.encrypt(str, key).should == [encrypted, key, iv]
      end
    end

    context 'when not passed a key' do
      let(:key) { "jshjw 43]9h&$nkjla()ndk}sj;ghdak" } # same here
      let(:encrypted) { "\xC5+\x91`\xC2\xE1_\xA0\xD9\xA3\v\xFB\xF4\x10\xF8\xB7\xEE!D\x1AC~\xCC\x1D\e\x8C\xF9\xF5\xAB\xAF\xC6$" }
      before { stubbed_aes.key = key }

      it 'encrypts the value' do
        stubbed_aes.stub(:random_key => key)
        subject.stub(:new_cipher => stubbed_aes)
        subject.encrypt(str).should == [encrypted, key, iv]
      end

      it 'uses a "random" key' do
        stubbed_aes.should_receive(:random_key).and_return(key)
        subject.stub(:new_cipher => stubbed_aes)
        subject.encrypt(str)
      end
    end

  end

  describe '.decrypt' do
    it 'decrypts from base64 to a marshaled object' do
      subject.decrypt(encrypted, key, iv).should == str
    end
  end


end
