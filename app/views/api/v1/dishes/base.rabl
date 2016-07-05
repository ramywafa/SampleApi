attributes :id, :created_at, :name, :description

node(:reviews_count) { |dish| dish.reviews.count }
