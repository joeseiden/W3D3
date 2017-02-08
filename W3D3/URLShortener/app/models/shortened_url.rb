require 'securerandom'

class ShortenedURL < ActiveRecord::Base
  include SecureRandom
  validates :short_url, :long_url, presence: true, uniqueness: true

  belongs_to :submitter,
    class_name: "User",
    foreign_key: :user_id,
    primary_key: :id

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

end
