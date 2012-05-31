module Credible
  class Credential
    attr_accessor :name, :value

    def description format = :short
      return '<empty>' if value.nil? || value == ''

      if :long == format
        value.inspect
      else
        truncated = value.to_s.sub(/\A(..).*(..)\Z/, '\1..\2')

        # yes, I *do* care that it /is_a/ String
        value.is_a?(String) ? truncated.inspect : truncated
      end
    end
  end
end
