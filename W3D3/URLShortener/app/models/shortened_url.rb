require 'securerandom'
require_relative 'visit'

class ShortenedURL < ActiveRecord::Base
  include SecureRandom
  validates :short_url, :long_url, presence: true, uniqueness: true

  belongs_to :submitter,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

  has_many :visits,
    class_name: 'Visit',
    foreign_key: :url_id,
    primary_key: :id

  has_many :visitors,
    Proc.new { distinct },
    through: :visits,
    source: :visitors

  def self.random_code
    short_url_code = SecureRandom.urlsafe_base64
    until !ShortenedURL.exists?(short_url: short_url_code)
      short_url_code = SecureRandom.urlsafe_base64
    end

    short_url_code
  end

  def self.generate(long_url, user)
    if ShortenedURL.exists?(long_url: long_url)
      return ShortenedURL.find_by long_url: long_url
    end
    short_url_code = ShortenedURL.random_code

    ShortenedURL.create!(short_url: short_url_code, long_url: long_url, user_id: user.id)
  end

  def num_clicks
    Visit.all.count { |url| url.url_id == self.id }
  end

  def num_uniques
    self.visitors.count
  end

  def num_recent_uniques
    self.visitors.where(["visits.created_at >= ?", 10.minutes.ago]).count
  end

end
