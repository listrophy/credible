require 'credible/ciphers/symmetric_cipher'
require 'credible/base64_helper'

module Credible
  module Ciphers
    class SymmetricObjectCipher < SymmetricCipher

      class << self

        include Credible::Base64Helper

        def encrypt obj, key64 = nil
          marshalled_obj = Marshal.dump(obj)
          key = key64 ? de64(key64) : nil

          ciphertext, key, iv = super(marshalled_obj, key)

          en64(ciphertext, key, iv)
        end

        def decrypt ciphertext64, key64, iv64
          ciphertext, key, iv = de64(ciphertext64, key64, iv64)
          Marshal.load super(ciphertext, key, iv)
        end

      end

    end
  end
end
