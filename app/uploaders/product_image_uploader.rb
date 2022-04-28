# encoding: utf-8

class ProductImageUploader < CarrierWave::Uploader::Base

  # Include RMagick or MiniMagick support:
  # include CarrierWave::RMagick
  include CarrierWave::MiniMagick

  # Include the Sprockets helpers for Rails 3.1+ asset pipeline compatibility:
  # include Sprockets::Helpers::RailsHelper
  # include Sprockets::Helpers::IsolatedHelper

  # Choose what kind of storage to use for this uploader:
  storage :file
  # storage :fog

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "system/uploads/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  # Provide a default URL as a default if there hasn't been a file uploaded:
  # def default_url
  #   # For Rails 3.1+ asset pipeline compatibility:
  #   # asset_path("fallback/" + [version_name, "default.png"].compact.join('_'))
  #
  #   "/images/fallback/" + [version_name, "default.png"].compact.join('_')
  # end

  # Process files as they are uploaded:
  # process :scale => [200, 300]
  #
  # def scale(width, height)
  #   # do something
  # end

  # Create different versions of your uploaded files:
  
  version :size_2400 do
    process :set_as_72_dpi_large
    process :resize_to_fill => [2400, 760, gravity = 'South']
    #process :extent => ['southwest',2400,600]
    process :quality => 25
  end
  
  version :size_1600 do
    process :set_as_72_dpi
    process :resize_to_fill => [1600, 1600]
  end
  
  version :size_1280 do
    process :set_as_72_dpi
    process :resize_to_fill => [1280, 1280]
  end
  
  version :size_960 do
    process :set_as_72_dpi
    process :resize_to_fill => [960, 460]
  end
  
  version :size_800 do
    process :set_as_72_dpi
    process :resize_to_fill => [800, 400]
  end
  
  version :size_300 do
    process :set_as_72_dpi
    process :resize_to_fill => [300, 150]
  end
  
  version :size_160 do
    process :set_as_72_dpi
    process :resize_to_fill => [160, 80]
  end
  
  version :thumbnail do
    process :set_as_72_dpi
    process :resize_to_fill => [20, 20]
  end
  
  def set_as_72_dpi
    manipulate! do |img|
      img.strip
      img.density('72')
      img.resize('1280')
      img.colorspace('sRGB')
      img = yield(img) if block_given?
      img
    end
  end
  
  def set_as_72_dpi_large
    manipulate! do |img|
      img.strip
      img.density('72')
      img.resize('2400')
      img.colorspace('sRGB')
      img = yield(img) if block_given?
      img
    end
  end
  

  # Crop
  def extent(direction,w,h)
    manipulate! do |img|      
      img.gravity(direction)
      img.extent("#{w}x#{h}")
      img
    end    
  end
  

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
  
  def extension_white_list
    %w(jpg)
  end

  # Override the filename of the uploaded files:
  # Avoid using model.id or version_name here, see uploader/store.rb for details.
  
  def filename
    "product_image.jpg" if original_filename
  end

end
