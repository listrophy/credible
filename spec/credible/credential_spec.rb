require 'spec_helper'

require 'credible/credential'

describe Credible::Credential do

  describe '#to_s' do

    context 'for empty-ish values' do
      after { subject.description.should == '<empty>' }
      it 'is <empty> for nil' do; end
      it 'is <empty> for ""' do
        subject.value = ''
      end
    end

    context 'for string-ish values' do
      before { subject.value = 'foobar' }

      context 'with default params' do
        it 'retuns a truncated string in quotes' do
          subject.description.should == '"fo..ar"'
        end
      end

      context 'with :long param' do
        it 'returns the string in quotes' do
          subject.description(:long).should == '"foobar"'
        end
      end

    end

    context 'for Fixnum values' do
      before { subject.value = 123456789 }

      context 'with default params' do
        it 'returns a truncated string' do
          subject.description.should == '12..89'
        end
      end

      context 'with :long param' do
        it 'returns the Fixnum as a string' do
          subject.description(:long).should == '123456789'
        end
      end

    end

  end

end
