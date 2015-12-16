class ReviewAvatarUploader < ImageUploader
  version :thumb do
    process :set_original_sha
    process convert: 'png'
    process resize_and_pad_png: [100, 100]
    process :set_content_type
  end

  def filename
    if original_filename.present? && model.student.present?
      "#{model.student.full_name.parameterize}-#{@original_sha}.png"
    else
      nil
    end
  end
end
