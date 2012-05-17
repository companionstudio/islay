class ImageUploader < AssetUploader
  include CarrierWave::RMagick

  process :preview

  def preview
    model.preview = file
  end

  version :admin_thumb do
    process :resize_to_fill => [200, 180, ::Magick::CenterGravity]
  end

  version :admin_thumb_small do
    process :resize_to_fill => [100, 90, ::Magick::CenterGravity]
  end
end
