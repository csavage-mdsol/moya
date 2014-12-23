require 'drds_decorator'

class DrdsController < ApplicationController
  before_filter :get_drd, except: [:index, :create]

  OPTIONS_KEYS = [ :conditions,
    :except,
    :only,
    :include,
    :exclude,
    :embed_optional,
    :additional_links,
    :override_links,
    :state
  ]

  def index
    @drds = Drd.all

    index_params.each do |k,v|
      @drds = @drds.public_send(k, v) if v.present?
    end

    # TODO: Fix this in Crichton.
    #       Crichton is blowing up when receiving ActiveRecord::Relation s
    decorator = DrdsDecorator.new(@drds.to_a, self)

    respond_with(decorator.value, options)
  end

  def show
    respond_with(@drd, options)
  end

  def create
    @drd = Drd.create!(create_params)

    respond_with(@drd, options)
  end

  def update
    @drd.update!(update_params)

    # TODO: Write and respond with a redirect object
    redirect_to url_for(@drd), status: :see_other
  end

  def activate
    @drd.activate!

    respond_with(@drd, options)
  end

  def deactivate
    @drd.deactivate!

    respond_with(@drd, options)
  end

  def destroy
    @drd.destroy!

    # Rails render no content still returns a 1 space body, this ensures no body
    render text: "", status: :no_content
  end

  private

  # NB: Allowing a requester to directly manipulate options is not normal.  It is a convenience for testing.
  def options
    params.slice(*OPTIONS_KEYS).symbolize_keys
  end

  def index_params
    params.permit(:status)
  end

  def create_params
    params.require(:drd).permit(:name, :status, :kind, :leviathan_uuid, :leviathan_url)
  end

  def update_params
    params.require(:drd).permit(:status, :old_status, :kind, :size, :location, :location_detail, :destroyed_status)
  end

  def get_drd
    # TODO: Fix this.  Gross.
    @drd = Drd.find(UUIDTools::UUID.parse(params[:id]))
  end

end
