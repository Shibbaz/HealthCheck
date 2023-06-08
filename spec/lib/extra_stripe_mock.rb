module StripeMock
    module RequestHandlers
      module Helpers
        def generate_card_token(card_params, token = nil)
          token = token || new_id('tok')
          card_params[:id] = new_id 'cc'
          @card_tokens[token] = Data.mock_card symbolize_names(card_params)
          token
        end
  
        def get_card_by_token(token)
          if token.nil? || @card_tokens[token].nil?
            return @card_tokens[generate_card_token({}, token)]
  
            msg = "Invalid token id: #{token}"
            raise Stripe::InvalidRequestError.new(msg, 'tok', 404)
          else
            @card_tokens.delete(token)
          end
        end
      end
    end
end