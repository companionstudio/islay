class CreateAssets < ActiveRecord::Migration
  def change
    create_table :assets do |t|
      t.integer   :asset_category_id,   :null => false, :on_delete => :cascade
      t.string    :type,                :null => false, :limit => 50
      t.string    :name,                :null => false, :limit => 200, :index => {:unique => true, :with => 'type'}
      t.string    :status,              :null => false, :default => 'pending'
      t.string    :upload,              :null => false, :limit => 200
      t.string    :path,                :null => false, :limit => 200
      t.string    :original_filename,   :null => false, :limit => 200

      # Thumbnails for video and documents
      t.string    :thumbnail,           :null => true, :limit => 200

      # Metadata
      t.integer   :filesize,            :null => true,  :precision => 20, :scale => 0
      t.string    :content_type,        :null => true,  :limit => 100

      # Image and Video
      t.string    :colorspace,          :null => true,  :limit => 20
      t.integer   :width,               :null => true,  :limit => 20
      t.integer   :height,              :null => true,  :limit => 20

      # Image
      t.boolean   :under_size,          :null => false, :default => false

      # Video
      t.string    :video_codec,         :null => true,  :limit => 50
      t.integer   :video_bitrate,       :null => true,  :limit => 15
      t.float     :video_frame_rate,    :null => true,  :limit => 15

      # Audio
      t.string    :audio_codec,         :null => true,  :limit => 50
      t.integer   :audio_bitrate,       :null => true,  :limit => 15
      t.integer   :audio_sample_rate,   :null => true,  :limit => 15
      t.integer   :audio_channels,      :null => true,  :limit => 2

      t.integer   :creator_id, :null => false, :references => :users
      t.integer   :updater_id, :null => false, :references => :users

      t.timestamps
    end
  end
end