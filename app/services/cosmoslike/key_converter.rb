class Cosmoslike::KeyConverter
  class << self
    def addr_to_bech32(hex_addr, prefix)
      prefix = prefix.sub(/1$/, '')
      bytes = [hex_addr].pack('H*').bytes
      Bitcoin::Bech32.encode(
        prefix,
        Bitcoin::Bech32.convert_bits(
          bytes,
          from_bits: 8, to_bits: 5, pad: true
        )
      )
    end

    def pubkey_to_addr(pubkey_bytes, prefix)
      prefix = prefix.sub(/1$/, '')
      addr_bytes = Bitcoin::Bech32.convert_bits(
        Digest::RMD160.digest(Digest::SHA256.digest(pubkey_bytes)).bytes,
        from_bits: 8, to_bits: 5, pad: true
      )
      Bitcoin::Bech32.encode(prefix, addr_bytes)
    end

    def pubkey_to_bech32(base64_pubkey_value, prefix)
      prefix = prefix.sub(/1$/, '')
      bytes = [
        *['1624DE6420'].pack('H*').bytes,
        *Base64.decode64(base64_pubkey_value).bytes
      ]

      Bitcoin::Bech32.encode(
        prefix,
        Bitcoin::Bech32.convert_bits(
          bytes,
          from_bits: 8, to_bits: 5, pad: true
        )
      )
    end
  end
end
