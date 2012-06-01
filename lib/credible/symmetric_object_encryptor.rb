require 'openssl'
require 'base64'

module Credible
  class SymmetricObjectEncryptor

    class << self

      def encrypt object, key64 = nil
        marshaled = Marshal.dump object
        key = key64 ? Base64.decode64(key64) : nil

        en64(*encipher(marshaled, key))
      end

      def decrypt str64, key64, iv64
        cryptext, key, iv = de64(str64, key64, iv64)

        marshaled = decipher(cryptext, key, iv)
        Marshal.load marshaled
      end



      def encipher cleartext, key = nil
        encryptor = new_cipher
        encryptor.encrypt

        iv = encryptor.random_iv
        key = (key ?  encryptor.key = key : encryptor.random_key)

        encrypted = encryptor.update cleartext
        encrypted << encryptor.final

        [encrypted, key, iv]
      end

      def decipher cryptext, key, iv
        decryptor = new_cipher
        decryptor.decrypt
        decryptor.iv = iv
        decryptor.key = key
        plaintext = decryptor.update cryptext
        plaintext << decryptor.final
      end

      def en64 *args
        args.map{|arg| Base64.encode64(arg).strip}
      end

      def de64 *args
        args.map{|arg| Base64.decode64 arg}
      end

      def new_cipher
        OpenSSL::Cipher::Cipher.new('AES-256-CBC')
      end

    end
  end
end
