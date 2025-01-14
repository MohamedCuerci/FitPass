require "stripe"

module Payments
  class StripeController < ApplicationController
    before_action :set_stripe_client, only: [ :new, :create ]

    def new
      # payment_intent = Stripe::PaymentIntent.create(
      #   amount: 1000, # em centavos
      #   currency: "brl",
      #   # automatic_payment_methods: {
      #   #   enabled: true
      #   # }
      #   payment_method_types: [
      #     "card",
      #     "boleto"
      #   ]
      # )

      # # { clientSecret: payment_intent.client_secret }.to_json
      # @client_secret = payment_intent.client_secret
    end

    def create
      payment_intent = Stripe::PaymentIntent.create(
        amount: 1000,
        currency: "brl",
        # automatic_payment_methods: {
        #   enabled: true
        # }
        payment_method_types: [
          "card",
          "boleto"
        ]
      )

      # AQUI EU PRECISO CRIAR UMA VARIAVEL PRA MANDAR OS DADOS DA COMPRA PRO STATUS

      render json: {
        clientSecret: payment_intent.client_secret
      }
    end

    def status
      # preciso passar aqui dentro o q comprei e o valor
      # basicamente os dados da compra
      @payment_intent_client_secret = params[:payment_intent_client_secret]
    end

    private

    def set_stripe_client
      # @sdk = Mercadopago::SDK.new(Rails.application.credentials.mercado_pago["access_token"])
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    end
  end
end
