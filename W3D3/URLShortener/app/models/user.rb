# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  email      :string           not null
#  created_at :datetime
#  updated_at :datetime
#

class User < ActiveRecord::Base
  validates :email, uniqueness: true, presence: true

  has_many :submitted_urls,
    class_name: "ShortenedURL",
    foreign_key: :user_id,
    primary_key: :id

  has_many :visits,
    class_name: 'Visit',
    foreign_key: :user_id,
    primary_key: :id

  has_many :visited_urls,
    Proc.new { distinct },
    through: :visits,
    source: :visited_urls


end
