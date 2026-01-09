json.extract! user, :id, :email, :name, :phone, :location, :created_at, :updated_at
json.url user_url(user, format: :json)
