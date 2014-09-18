json.array!(@users) do |user|
  json.extract! user, :id, :name, :email, :grad_date, :city
  json.url user_url(user, format: :json)
end
