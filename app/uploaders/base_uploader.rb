class BaseUploader < CarrierWave::Uploader::Base
  # Override to silently ignore trying to remove missing previous file
  def remove!
    super
  rescue Fog::Storage::S3::NotFound
    self.column_null!
  end

  def column_null!
    ActiveRecord::Base.connection.execute("UPDATE #{model.class.table_name} SET #{mounted_as}=null WHERE id = #{model.id}")
    model.send(:write_attribute, mounted_as, nil)
  end

  # Here we check on column null instead of relying on Carrierwave
  # If the image currently is being deleted we don't want it visible
  def column_null?
    column_filename.nil?
  end

  def column_filename
    model.send(:read_attribute, mounted_as)
  end

  def column_filename= filename
    filename = File.basename(filename) # drop the path from the file
    connection = ActiveRecord::Base.connection
    connection.execute("UPDATE #{model.class.table_name} SET #{mounted_as}='#{connection.quote_string(filename)}' WHERE id = #{model.id}")
    model.send(:write_attribute, mounted_as, filename)
  end

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end
end
