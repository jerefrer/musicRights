class Song < ActiveRecord::Base
  has_attached_file :song,
#        :path => ":rails_root/public/:basename.:extension"
        :storage => :s3,
        :s3_credentials => "#{RAILS_ROOT}/config/s3_config.yaml",
        :path => ":attachment/:id/:style.:extension",
        :bucket => 'music-rights-media'

  # Acts as taggable on
  acts_as_taggable

  # Paperclip Validations
  validates_attachment_presence :song
  validates_attachment_content_type :song, :content_type => [ 'application/mp3', 'application/x-mp3', 'audio/mpeg', 'audio/mp3' ]
end