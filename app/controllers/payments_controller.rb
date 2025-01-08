require 'mercadopago'

class PaymentsController < ApplicationController
  before_action :set_mercado_pago_client, only: [:new, :process_payment]

  def new
    # falta implementar aqui dentreo talvez
    # aparte de back end do app
    # https://www.mercadopago.com.br/developers/pt/live-demo/payment-brick

    # em teoria eu ja teria selecionado o produto q quero comprar
    # ex:
    # @products.all


    # Cria um objeto de preferência
    # preference_data = {
    #   # o purpose: 'wallet_purchase', permite apenas pagamentos logados
    #   # para permitir pagamentos como guest, você pode omitir essa propriedade
    #   # purpose: 'wallet_purchase',
    #   items: [
    #     {
    #       title: 'Meu produto',
    #       unit_price: 75.56,
    #       quantity: 1
    #     }
    #   ],
    #   transaction_amount: 150,
    #   description: 'Produto teste',
    #   payment_method_id: 'pix',
    #   payer: {
    #     email: 'test@test.com',
    #     identification: {
    #       type: 'CPF',
    #       number: '19119119100',
    #     }
    #   },
    #   back_urls: {
    #     success: 'http://localhost:3000/status_payment/',
    #     failure: 'http://localhost:3000/status_payment/',
    #     pending: 'http://localhost:3000/status_payment/'
    #   },
    #   auto_return: 'approved',
    #   callback_url: "http://localhost:3000/payments/process_payment"
    # }

    # tentar jogar isso lá pra cima
    # payment_request = {
    #   transaction_amount: 100,
    #   description: 'Título do produto',
    #   payment_method_id: 'pix',
    #   payer: {
    #     email: 'test@test.com',
    #     identification: {
    #       type: 'CPF',
    #       number: '19119119100',
    #     }
    #   }
    # }

    # preference_response = @sdk.preference.create(preference_data)
    # preference = preference_response[:response]
    # @preference_id = preference['id']

    # payment_response = @sdk.payment.create(preference_data)
    # p payment_response[:response]
    # payment = payment_response[:response]

    # @price = preference_data[:items].first[:unit_price]


    # -------------------------------------------------------------

    # tentantiva seguindo apenas a documentação
    # payment_data = {
    #   transaction_amount: 200,
    #   token: params[:token],
    #   description: params[:description],
    #   installments: 1,
    #   payment_method_id: params[:paymentMethodId],
    #   payer: {
    #     email: 'test@test.com',
    #     identification: {
    #       type: 'CPF',
    #       number: '19119119100'
    #     },
    #     first_name: 'teste'
    #   }
    # }

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
          "success": "http://localhost:3000/status_payment/",
          "failure": "http://localhost:3000/status_payment/",
          "pending": "http://localhost:3000/status_payment/"
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
  

    # payment_response = @sdk.payment.create(payment_data)
    # payment = payment_response[:response]

    # @preference_id = payment['id']
    @price = 15000

    # pelo q entendi o back_urls e auto_return são setados em
    # preference_response = @sdk.preference.create(preference_data)
    # preciso investigar melhor isso

    # puts payment
  end

  def create
    # eu devo juntar os parametros q vem do new/formulario e tentar salvar

    # apartir disso redirecionado para devolta para o formulario ou pro pagina de status
    #OBS: EM TEORIA, O METODO process_payment ESTA SERVINDO COMO CREATE
  end

  def process_payment
    # sdk = Mercadopago::SDK.new(ENV['MERCADO_PAGO_ACCESS_TOKEN'])

    # aqui eu pego um hash q diferencia baseado no metodo de pagamento
    @payment_request = if params[:payment_method_id] == "pix"
      billet_pix(params)
    else
      card_and_credit(params)
    end

    # # payment_response = sdk.payment.create(payment_data)
    # em teoria só preicos dar um @sdk.payment.create(@payment_request)
    # pois n tem necessidade de criar a variavel @payment
    # o q causa duas vzs cada valor nos params
    @payment_response = @sdk.payment.create(@payment_request)
    @payment = @payment_response[:response]
    
    # debugger
    #nesse debuger preciso ver se tenho o @payment e se tenho um @payment_id q deveria retornar junto com 
    #
    # 
    # 
    # 
    
    # aqui em teoria ele redireciona para a back_urls devinidas no metodo NEW
    
    respond_to do |format|
      if @payment.present? 
        format.html { redirect_to status_payment_path(@payment['id']), status: :see_other, notice: "Pagamento realizado com sucesso!" }
        # format.json { status: 'success', payment_id: @payment['id'], payment_details: @payment }
      else
        flash[:error] = @payment['status_detail']
        redirect_to :new, status: :unprocessable_entity
        # render json: { status: 'failure', error: payment['status_detail'] }, status: :unprocessable_entity
      end
    end
    # https://www.mercadopago.com.br/developers/pt/live-demo/status-screen-brick
  end

  def status
    a = 2
    # debugger

    @payment_id = params[:payment_id] # Obtém o payment_id da URL
    # @dale = params[:merchant_order_id]
  end

  private

  def set_mercado_pago_client
    @sdk = Mercadopago::SDK.new(Rails.application.credentials.mercado_pago["access_token"])
  end

  def card_and_credit(params)
    {
      transaction_amount: params[:transaction_amount],
      token: params[:token], # preciso saber a origem desse token
      description: "Produto teste aqui do controller",
      installments: params[:installments],
      payment_method_id: params[:payment_method_id],
      payer: {
        email: params[:payer][:email],
        identification: {
          type: "CPF",
          number: "19119119100"
        },
        first_name: "Lucas",
        last_name: "Soares"
      }
    }
  end 

  def billet_pix(params)
    # # pix
    {
      transaction_amount: params[:transaction_amount],
      description: 'Produto teste aqui do controller',
      payment_method_id: params[:payment_method_id],
      payer: {
        email: params[:payer][:email],
        identification: {
          type: 'CPF',
          number: '19119119100',
        }
      }
    }
  end

  def billet_ticket(params)
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
