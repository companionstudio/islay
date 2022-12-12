class Islay::Admin::AssetLibraryController < Islay::Admin::ApplicationController
  header 'Asset Library'
  nav_scope :asset_library

  def index
    @groups         = AssetGroup.summary.order('name')
    @latest_assets  = Asset.limit(11).order("updated_at DESC")
    @asset_tags     = AssetTag.order('name')
  end

  def browser
    @albums = AssetGroup.of(params[:only]).order('name ASC')

    @assets = if params[:only]
      Asset.summaries.of(params[:only])
    else
      Asset.latest
    end

    render :json => albums_and_assets_response
  end

  private

  def albums_and_assets_response
    albums = @albums.map do |album|
      {
        id: album.id,
        name: album.name,
        count: album.assets_count
      }
    end

    assets = @assets.map do |asset|
      {
        id:  asset.id
        album_id: asset.asset_group_id
        name:  asset.name
        kind:  asset.kind
        friendly_kind:  asset.friendly_kind
        extension:  asset.extension
        url:  asset.previews.url(:thumb_medium)
        previewable: asset.preview?
        latest: asset.latest?
      }
    end

    {
      albums: albums,
      assets: assets
    }
  end


end
