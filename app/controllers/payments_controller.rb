require 'mercadopago'

class PaymentsController < ApplicationController
  # protect_from_forgery with: :null_session
  before_action :set_mercado_pago_client, only: [:new, :process_payment]

  def new
    # https://www.mercadopago.com.br/developers/pt/live-demo/payment-brick

    payment_request = {
      transaction_amount: 100,
      description: 'Título do produto',
      payment_method_id: 'pix',
      payer: {
        email: 'test@test.com',
        identification: {
          type: 'CPF',
          number: '19119119100',
        }
      }
    }

    preference_data = {
      items: [
        {
          "id": "item-ID-1234",
          "title": "Meu produto teste um",
          "currency_id": "BRL",
          # "picture_url": "https://www.mercadopago.com/org-img/MP3/home/logomp3.gif",
          "description": "Descrição do Item",
          "category_id": "art",
          "quantity": 1,
          "unit_price": 75.76
        }
      ],
      payer: {
        "name": "test men cuerci",
        "email": "test@test.com",
        # "phone": {
        #     "area_code": "<PAYER_AREA_CODE_HERE>",
        #     "number": "<PAYER_PHONE_NUMBER_HERE>"
        # },
        # "identification": {
        #     "type": "<PAYER_DOC_TYPE_HERE>",
        #     "number": "<PAYER_DOC_NUMBER_HERE>"
        # },
        # "address": {
        #     "street_name": "Street",
        #     "street_number": 123,
        #     "zip_code": "<PAYER_ZIP_CODE_HERE>"
        # }
      },
      back_urls: {
          "success": "http://localhost:3000/process_payment/", # talvez trocar para process_payment
          "failure": "http://localhost:3000/process_payment/",
          "pending": "http://localhost:3000/process_payment/"
      },
      auto_return: "approved",
      payment_methods: {
        # "excluded_payment_methods": [
        #     {
        #         "id": "master"
        #     }
        # ],
        # "excluded_payment_types": [
        #     {
        #         "id": "ticket"
        #     }
        # ],
        "installments": 12
      },
      statement_descriptor: "FitPass",
    }

    # @sdk.preference serve para definir suas preferencias como redirecionamento, usuario e etc
    # para usar precisar passar seu id no formulario 
    # https://www.mercadopago.com.br/developers/pt/docs/checkout-bricks/payment-brick/advanced-features/preferences
    preference_response = @sdk.preference.create(preference_data)
    preference = preference_response[:response]
    @preference_id = preference['id']

    payment_response = @sdk.payment.create(payment_request)
    # payment = payment_response[:response]

    @price = 150

    respond_to do |format|
      format.html
      format.js
    end
  end

  def create
    # eu devo juntar os parametros q vem do new/formulario e tentar salvar

    # apartir disso redirecionado para devolta para o formulario ou pro pagina de status
    #OBS: EM TEORIA, O METODO process_payment ESTA SERVINDO COMO CREATE
  end

  def process_payment
    # payment_data = JSON.parse(request.body.read)

    # aqui eu pego um hash q diferencia baseado no metodo de pagamento
    @payment_request = if params[:payment_method_id] == "pix"
      billet_pix(params)
    else
      card_and_credit(params)
    end

    @payment_response = @sdk.payment.create(@payment_request)
    @payment = @payment_response[:response]
    @redirect_url = status_payment_path(@payment['id'])

    if @payment.present?
      render json: { status: 'success', payment_id: @payment['id'], redirect_url: @redirect_url }
    else
      render json: { status: 'error', error: @payment['status_detail'] || "Erro ao processar o pagamento"}, status: :unprocessable_entity
    end
  end

  def status
    # https://www.mercadopago.com.br/developers/pt/live-demo/status-screen-brick
    @payment_id = params[:payment_id]

    respond_to do |format|
      format.html
      format.js
    end
  end

  private

  def set_mercado_pago_client
    @sdk = Mercadopago::SDK.new(Rails.application.credentials.mercado_pago["access_token"])
  end

  def card_and_credit(payment_data)
    {
      transaction_amount: payment_data[:transaction_amount],
      token: payment_data[:token], # preciso saber a origem desse token
      description: "Produto teste aqui do controller",
      installments: payment_data[:installments],
      payment_method_id: payment_data[:payment_method_id],
      payer: {
        email: payment_data["payer"]["email"],
        identification: {
          type: "CPF",
          number: "19119119100"
        },
        first_name: "Lucas",
        last_name: "Soares"
      }
    }
  end 

  def billet_pix(payment_data)
    {
      transaction_amount: payment_data[:transaction_amount],
      description: 'Produto teste aqui do controller',
      payment_method_id: payment_data[:payment_method_id],
      payer: {
        email: payment_data["payer"]["email"],
        identification: {
          type: 'CPF',
          number: '19119119100',
        }
      }
    }
  end

  def billet_ticket(payment_data)
    {
      transaction_amount: 100,
      description: 'Título do produto',
      payment_method_id: 'bolbradesco',
      payer: {
        email: 'test@test.com',
        first_name: 'Test',
        last_name: 'User',
        identification: {
          type: 'CPF',
          number: '19119119100',
        },
        address: {
          zip_code: '06233200',
          street_name: 'Av. das Nações Unidas',
          street_number: '3003',
          neighborhood: 'Bonfim',
          city: 'Osasco',
          federal_unit: 'SP'
        }
      }
    }
  end
end
