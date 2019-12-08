module SessionHelper
  # initializes public key used for password encryption
  #
  def generate_rsa_key
    rsa_key = RsaEncryptor.new
    session[:rsa_key] = rsa_key.serialized_data
    @public_key = rsa_key.public_key.to_s
  end

  # decrypts the password using private key
  #
  # @param [Array<string>] user_params_keys An array specifying user parameters to be decrypted
  #
  def authenticate_encryptor(user_params_keys)
    rsa_key = RsaEncryptor.build_key(session[:rsa_key])
    user_params_keys.each do |key|
      request.params[:user][key] = rsa_key.private_decrypt(Base64.decode64(request.params[:user][key])) rescue ''
    end
  end
end
