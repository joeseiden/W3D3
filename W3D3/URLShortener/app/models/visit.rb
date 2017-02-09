class Visit < ActiveRecord::Base
  validates :user_id, :url_id, presence: true

  belongs_to :visitors,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  belongs_to :visited_urls,
    class_name: "ShortenedURL",
    foreign_key: :url_id,
    primary_key: :id

  def self.record_visit!(user, shortened_url)
    Visit.create!(user_id: user.id, url_id: shortened_url.id)
  end

end
