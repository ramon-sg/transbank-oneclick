Transbank::Oneclick.configure do |config|
  # config.url               = "ONECLICK_SOAP_URL"
  # config.cert_path         = "RELATIVE_PATH_TO_CRT_FILE"
  # config.key_path          = "RELATIVE_PATH_TO_KEY_FILE"
  # config.server_cert_path  = "RELATIVE_PATH_TO_SERVER_CRT_FILE"

  # These are the default options for Net::HTTP
  # it is also possible to pass them on every request
  # reverse with read_timeout 60 seconds: Transbank::Oneclick.reverse(24575755, http_options: {read_timeout: 60})
  # Default is  {}
  # config.http_options = { read_timeout: 80 }

  # ignores any exception passed as argument
  # not capture any exception: config.rescue_exceptions []
  # Default is [Net::ReadTimeout, Timeout::Error, Errno::EINVAL, Errno::ECONNRESET, EOFError,	Net::HTTPBadResponse, Net::HTTPHeaderSyntaxError, Net::ProtocolError]
  # config.rescue_exceptions = [Net::ReadTimeout, Timeout::Error, Transbank::Oneclick::Exceptions::InvalidSignature]
end