require 'openssl'
require 'base64'

module Credible
  class SymmetricObjectEncryptor

    class << self

      def encrypt object, key, iv = nil
        marshaled = Marshal.dump object
        encrypted, iv = encipher(marshaled, key, iv)
        [Base64.encode64(encrypted).strip, iv]
      end

      def decrypt str, key, iv
        cryptext = Base64.decode64(str)
        marshaled = decipher(cryptext, key, iv)
        Marshal.load marshaled
      end

      def encipher cleartext, key, iv = nil
        encryptor = OpenSSL::Cipher.new('AES-256-CBC')
        encryptor.encrypt

        iv = iv ? encryptor.iv = iv : encryptor.random_iv
        encryptor.key = key

        encrypted = encryptor.update cleartext
        encrypted << encryptor.final

        [encrypted, iv]
      end

      def decipher cryptext, key, iv
        decryptor = OpenSSL::Cipher::Cipher.new('AES-256-CBC')
        decryptor.decrypt
        decryptor.iv = iv
        decryptor.key = key
        plaintext = decryptor.update cryptext
        plaintext << decryptor.final
      end

    end
  end
end
