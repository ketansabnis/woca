class RsaEncryptor
  attr_reader :rsa_key, :public_key

  def initialize
    @rsa_key = OpenSSL::PKey::RSA.generate(1024)
    @public_key = @rsa_key.public_key.to_s
  end

  # serializes the data extracted for the key in order to use it in session
  #
  #
  # @return [String] JSON serialized data
  #
  def serialized_data
    params = {}
    rsa_key.params.each { |k, v| params[k] = v.to_s }
    params.to_json
  end

  # Rebuilds RSA key from serialized data
  #
  # @param [String] serialized_key A serialized key
  #
  # @return [OpenSSL::PKey::RSA] A RSA key object
  #
  def self.build_key(serialized_key)
    rsa_key = OpenSSL::PKey::RSA.new(1024)
    rsa_key_params = JSON.parse(serialized_key)
    rsa_key_params.each { |k, v| rsa_key_params[k] = OpenSSL::BN.new(v) }
    rsa_key.set_key(rsa_key_params['n'], rsa_key_params['e'], rsa_key_params['d'])
    rsa_key.set_factors(rsa_key_params['p'], rsa_key_params['q'])
    rsa_key.set_crt_params(rsa_key_params['dmp1'], rsa_key_params['dmq1'], rsa_key_params['iqmp'])
    rsa_key
  end
end