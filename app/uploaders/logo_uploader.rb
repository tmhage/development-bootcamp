class LogoUploader < ImageUploader
  version :thumb do
    process :set_original_sha
    process convert: 'png'
    process resize_and_pad_png: [100, 100]
    process :set_content_type
  end
end
