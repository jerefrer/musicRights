class CreateSongs < ActiveRecord::Migration
  def self.up
    create_table :songs do |t|
      t.string :name
      t.string :song_file_name
      t.string :song_content_type
      t.integer :song_file_size
      t.datetime :song_updated_at
      t.integer :category_id

      t.timestamps
    end
  end

  def self.down
    drop_table :songs
  end
end
