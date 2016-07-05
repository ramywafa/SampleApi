attributes :id, :created_at, :name, :description, :creator_type

node(:reviews_count) { |dish| dish.reviews.count }

child(:reviews) do
  extends 'api/v1/reviews/base'
end

child(:creator) do
  node do |creator|
    if creator.is_a?(User)
      partial("api/v1/users/_user", object: creator)
    else
      partial("api/v1/admins/_admin", object: creator)
    end
  end
end
