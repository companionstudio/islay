class Islay::Admin::PagesController < Islay::Admin::ApplicationController
  header 'Page Content'
  before_filter :find_page,   :except => [:index]
  before_filter :find_assets, :except => [:index]

  def index
    @pages = Islay::Engine.content.pages
    @shared = Islay::Engine.content.shares
  end

  def edit

  end

  def update
    if @page.update_attributes(params[:page])
      redirect_to path(:edit, @page)
    else
      render :edit
    end
  end

  private

  def find_assets
    @assets = ImageAsset.order('name')
  end

  def find_page
    @page = Page.where(:slug => params[:id]).first || Page.new(:slug => params[:id])
  end
end
