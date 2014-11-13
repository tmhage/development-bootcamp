# encoding: utf-8

class ImageUploader < BaseUploader
  include CarrierWave::MiniMagick

  attr_accessor :original_sha

  process :set_original_sha

  def store_dir
    "uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def filename
    if original_filename.present?
      "#{model.slug}-#{@original_sha}.png"
    else
      nil
    end
  end

  def set_original_sha
    if File.exists?(self.file.file)
      @original_sha = `openssl md5 #{self.file.file}`.split(" ").last
    else
      raise "file does not exist!"
    end
  end

  def resize_and_pad_png(width, height, background=:transparent, gravity='Center')
    manipulate! do |img|
      img.format 'png'
      img.combine_options do |cmd|
        cmd.thumbnail "#{width}x#{height}>"
        if background == :transparent
          cmd.background "rgba(255, 255, 255, 0.0)"
        else
          cmd.background background
        end
        cmd.gravity gravity
        cmd.extent "#{width}x#{height}"
      end
      img = yield(img) if block_given?
      img
    end
  end

  def set_content_type(*args)
    self.file.instance_variable_set(:@content_type, 'image/png')
  end
end
