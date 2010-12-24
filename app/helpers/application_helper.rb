module ApplicationHelper
  def s3_upload
    # s3.yml is a file in the config folder, it's formatted for paperclip
    s3config = YAML.load_file("#{RAILS_ROOT}/config/amazon_s3.yml")
#    bucket = s3config['production']['bucket']
#    access_key = s3config['production']['access_key_id']
#    secret = s3config['production']['secret_access_key']
    bucket = s3config['bucket']
    access_key = s3config['access_key_id']
    secret = s3config['secret_access_key']
    key = "uploads/"
    expiration = 10.hours.from_now.utc.strftime('%Y-%m-%dT%H:%M:%S.000Z')
    max_filesize = 30.megabytes
    sas = '201' # Tells amazon to redirect after success instead of returning xml
    policy = Base64.encode64(
      "{'expiration': '#{expiration}',
        'conditions': [
          {'bucket': '#{bucket}'},
          ['starts-with', '$key', '#{key}'],
          {'success_action_status': '#{sas}'},
          ['content-length-range', 1, #{max_filesize}],
          ['starts-with', '$filename', ''],
          ['starts-with', '$folder', ''],
          ['starts-with', '$fileext', '']
        ]}
      ").gsub(/\n|\r/, '')
    signature = Base64.encode64(OpenSSL::HMAC.digest(OpenSSL::Digest::Digest.new('sha1'), secret, policy)).gsub(/\n| |\r/, '')
    {:access_key => access_key, :key => key, :policy => policy, :signature => signature, :sas => sas, :bucket => bucket}
  end
  
  def load_uploadify
    uploadify = s3_upload
    "var S3_BUCKET='http://#{uploadify[:bucket]}.s3.amazonaws.com/';\n
     var UPLOADIFY = { 'AWSAccessKeyId' : encodeURIComponent(encodeURIComponent('#{uploadify[:access_key]}')),
     'key': encodeURIComponent(encodeURIComponent('#{uploadify[:key]}${filename}')),
     'policy': encodeURIComponent(encodeURIComponent('#{uploadify[:policy]}')),
     'signature': encodeURIComponent(encodeURIComponent('#{uploadify[:signature]}')),
     'success_action_status': '#{uploadify[:sas]}',
     'folder': '',
     'Filename': '' };"
  end
end
