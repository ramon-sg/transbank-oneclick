module Transbank
  module Oneclick
    class Api
      ATTRIBUTES = {
        # init_inscription
        email:        :email,
        response_url: :responseURL,
        username:     :username,

        # finish_inscription
        token: :token,

        # authorize
        amount:     :amount,
        tbk_user:   :tbkUser,
        username:   :username,
        buy_order:  :buyOrder,

        # code_reverse_one_click
        # buyorder: :buyorder,

        # remove_user
        # tbk_user:  :tbkUser,
        # username:  :username
      }

      def init_inscription(params = {}, opt = {})
        call :initInscription, params, opt
      end

      def finish_inscription(token, opt = {})
        call :finishInscription, {token: token}, opt
      end

      def authorize(params = {}, opt = {})
        call :authorize, params, opt
      end

      def reverse(buy_order, opt = {})
        call :codeReverseOneClick, {buyorder: buy_order}, opt
      end

      def remove_user(params = {}, opt = {})
        call :removeUser, params, opt
      end

      private
        def call(action, params = {}, opt = {})
          params = build_params(params)
          request = Request.new action, params, opt
          request.response
        end

        def build_params(hash)
          hash.map {|k, v| [ATTRIBUTES.fetch(k.to_sym, k), v]}.to_h
        end
    end
  end
end
