require 'credible/base64_helper'

describe Credible::Base64Helper do
  subject { Class.new { extend Credible::Base64Helper } }

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
