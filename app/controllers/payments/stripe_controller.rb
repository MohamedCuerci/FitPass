module Payments
  class StripeController < ApplicationController
    before_action :set_stripe_client, only: [:new, :process_payment]

    def new
    end

    private
    
    def set_stripe_client
      # @sdk = Mercadopago::SDK.new(Rails.application.credentials.mercado_pago["access_token"])
    end
  end
end