json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :city
  json.url user_url(user, format: :json)
end
