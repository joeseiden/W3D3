class CreateShortenedUrls < ActiveRecord::Migration
  def change
    create_table :shortened_urls do |t|
      t.string :short_url, NULL: false
      t.string :long_url, NULL: false
      t.integer :user_id, null: false

      t.timestamps
    end

    add_index(:shortened_urls, :short_url)
    add_index(:shortened_urls, :long_url)
    add_index(:shortened_urls, :user_id)
  end
end
