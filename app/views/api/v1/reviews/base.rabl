attributes :dish_id, :created_at, :id, :content, :rating, :reviewer_type

child(:reviewer) do
  node do |reviewer|
    if reviewer.is_a?(User)
      partial("api/v1/users/_user", object: reviewer)
    else
      partial("api/v1/admins/_admin", object: reviewer)
    end
  end
end
