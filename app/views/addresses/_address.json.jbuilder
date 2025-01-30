json.extract! address, :id, :gym_id, :street, :number, :complement, :neighborhood, :city, :state, :latitude, :longitude, :created_at, :updated_at
json.url address_url(address, format: :json)
