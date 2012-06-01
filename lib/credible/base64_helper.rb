require 'base64'

module Credible
  module Base64Helper

    def en64 *args
      args.map{|arg| Base64.encode64(arg).strip}
    end

    def de64 *args
      args.map{|arg| Base64.decode64 arg}
    end

  end
end
