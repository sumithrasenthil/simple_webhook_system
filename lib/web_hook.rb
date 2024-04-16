# module for sending webhook notifications with HMAC signature authentication.
module WebHook
  class << self
    def send(details, data)
      response = HTTParty.post(details.end_point,
                               body: data.to_json,
                               headers: { 'X-Webhook-Signature': generate_hmac_signature(data, details.secret), 'Content-Type' => 'application/json' })

      handle_response(response)
    end

    private

    def generate_hmac_signature(data, secret_key)
      payload = data.as_json.to_json
      digest = OpenSSL::Digest.new('sha256')
      hmac = OpenSSL::HMAC.hexdigest(digest, secret_key, payload)
      Base64.strict_encode64(hmac)
    end

    def handle_response(response)
      if response.success?
        Rails.logger.info('Webhook sent successfully')
      else
        Rails.logger.error("Webhook failed: #{response.code} - #{response.body}")
      end
    end
  end
end
