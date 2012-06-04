require 'openssl'

module Credible
  module Ciphers
    class AsymmetricCipher
      class << self

        def encrypt plaintext, pub_key
          key(pub_key).public_encrypt(plaintext)
        end

        def decrypt ciphertext, priv_key
          key(priv_key).private_decrypt(ciphertext)
        end

        def key key
          OpenSSL::PKey::RSA.new(key)
        end

      end
    end
  end
end
