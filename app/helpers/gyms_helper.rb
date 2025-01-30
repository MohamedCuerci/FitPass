module GymsHelper
  def format_address(address)
    # address = [street, number, neighborhood, city, state].compact.join(", ")
    # [address, cep].join(" - ")

    "#{address.street}, #{address.number} - #{address.neighborhood} #{address.city}, #{address.state} - #{address.cep}"
  end
end
