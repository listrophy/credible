require 'spec_helper'

require 'credible/credential_set'

describe Credible::CredentialSet do
  describe '#list' do
    it 'returns an alphabetized array of credential names' do
      subject << stub(:name => 'ccc')
      subject << stub(:name => 'aaa')
      subject << stub(:name => 'bbb')
      subject.list.should == %w(aaa bbb ccc)
    end
  end
end
