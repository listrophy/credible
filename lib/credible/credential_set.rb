module Credible
  class CredentialSet < Array
    attr_accessor :name
    def list
      map(&:name).sort
    end
  end
end
