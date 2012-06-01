require 'openssl'

module Credible
  module Ciphers
    class SymmetricCipher

      class << self

        def encrypt plaintext, key = nil
          encryptor = new_cipher
          encryptor.encrypt

          iv = encryptor.random_iv
          key = (key ? encryptor.key = key : encryptor.random_key)

          encrypted = encryptor.update plaintext
          encrypted << encryptor.final

          [encrypted, key, iv]
        end

        def decrypt ciphertext, key, iv
          decryptor = new_cipher
          decryptor.decrypt
          decryptor.iv = iv
          decryptor.key = key
          plaintext = decryptor.update ciphertext
          plaintext << decryptor.final
        end

        def new_cipher
          OpenSSL::Cipher::Cipher.new('AES-256-CBC')
        end

      end

    end
  end
end
