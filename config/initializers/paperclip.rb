Paperclip.interpolates('isbn') do |attachment, style|
  attachment.instance.isbn
end

Paperclip.interpolates('title_id') do |attachment, style|
  attachment.instance.title_id
end

Paperclip::Attachment.default_options.merge!(
  :storage => 's3',
  :s3_credentials => YAML.load_file("#{Rails.root}/config/aws-s3.yml")
)