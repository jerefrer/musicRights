class Song < ActiveRecord::Base
  has_attached_file :song,
        :storage => :s3,
        :s3_credentials => "#{RAILS_ROOT}/config/s3_config.yaml",
        :path => ":attachment/:id/:style.:extension",
        :bucket => 'media'

  # Acts as taggable on
  acts_as_taggable

  # Paperclip Validations
  validates_attachment_presence :song
  validates_attachment_content_type :song, :content_type => ['mp3']
end