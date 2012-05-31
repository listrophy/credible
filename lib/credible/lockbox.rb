module Credible
  class Lockbox < Hash
    def add_credential_set credential_set
      self[credential_set.name] = credential_set
    end

    def list
      Hash[sort]
    end
  end
end
