json.extract! contact, :id, :gym_id, :contact_type, :value, :created_at, :updated_at
json.url contact_url(contact, format: :json)
