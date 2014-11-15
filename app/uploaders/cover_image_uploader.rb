class CoverImageUploader < ImageUploader
  version :big do
    process :set_original_sha
    process convert: 'png'
    process resize_to_fit: [1000, 1000]
    process :set_content_type
  end

  version :small do
    process :set_original_sha
    process convert: 'png'
    process resize_to_fit: [500, 500]
    process :set_content_type
  end

  version :thumb do
    process :set_original_sha
    process convert: 'png'
    process resize_and_pad_png: [100, 100]
    process :set_content_type
  end
end
