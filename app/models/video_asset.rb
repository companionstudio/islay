class VideoAsset < Asset
  self.kind = 'video'
  mount_uploader :upload, VideoUploader
end