require "stripe"

module Payments
  class StripeController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [ :webhook ]
    before_action :set_stripe_client, only: [ :new, :create ]

    def new
      @name = params[:name]
      @amount = params[:amount]
    end

    def create
      # a = 1
      # debugger

      payment_intent = Stripe::PaymentIntent.create(
        amount: params[:items].first["amount"].to_i * 100 + 90,
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

    # webhook pra quando alguem pagar atraves do link de pagamento
    # antes eu preciso fazer o deploy pra testar
    def webhook
      endpoint_secret = Rails.application.credentials.stripe[:webhook_secret]
      # # preciso pegar essa informação ainda, acredito q apos configurar a url pro webhook ele fornece isso
      # endpoint_secret = "" # talvez temporaria
      payload = request.body.read
      sig_header = request.env["HTTP_STRIPE_SIGNATURE"] # entender melhor oq é isso
      # sig_header = É um header que o Stripe envia em cada requisição webhook. Contém a assinatura da requisição

      begin
        event = Stripe::Webhook.construct_event(
          payload, sig_header, endpoint_secret
        )

        # essa tabela ta sendo criado na intenção de pagamento
        # Criar essa tabela para salvar o evento
        if event.type == "checkout.session.completed" || event.type == "payment_intent.succeeded"
          # trigger_create_stripe_event(event) tirar o codigo abaixo e colocar esse
          stripe_event = StripeEvent.create!(
            stripe_id: event.id,
            event_type: event.type,
            status: "pending",
            metadata: event.data.object.to_hash
          )
        end

        case event.type
        when "checkout.session.completed"
          session = event.data.object

          # Processar o pagamento bem-sucedido
          # process_successful_payment(session) # comentado ate ter algo pra fazer
          puts "pagamento realizado com sucesso" if session

          stripe_event.update(status: 'processed')
        end

        render json: { received: true }
      rescue JSON::ParserError => e
        render json: { error: e.message }, status: 400
      rescue Stripe::SignatureVerificationError => e
        render json: { error: e.message }, status: 400
      end
    end

    private

    def set_stripe_client
      Stripe.api_key = Rails.application.credentials.dig(:stripe, :secret_key)
    end

    # aqui eu coloco a logica caso o pagamento seja bem sucedido
    def process_successful_payment(session)
      user = User.find_by(email: session.customer_details.email)
      # user = User.first
      return unless user

      # Atualizar informações do usuário baseado no produto/preço comprado
      # preciso setar os metadados ainda
      case session.metadata.plan_type
      when "basic"
        user.update(
          subscription_status: 'active',
          plan_type: 'basic',
          subscription_ends_at: 30.days.from_now
        )
      when 'premium'
        user.update(
          subscription_status: 'active',
          plan_type: 'premium',
          subscription_ends_at: 30.days.from_now
        )
      when 'business'
        user.update(
          subscription_status: 'active',
          plan_type: 'business',
          subscription_ends_at: 30.days.from_now
        )
      end
    end

    def trigger_create_stripe_event(event)
      # criar evento aqui
    end
  end
end
