require 'drds_decorator'

class DrdsController < ApplicationController
  respond_to :hale_json

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

    filtering_params(params).each do |k,v|
      @drds = @drds.public_send(key, value) if value.present?
    end

    # TODO: Fix this in Crichton.
    #       Crichton is blowing up when receiving ActiveRecord::Relation s
    decorator = DrdsDecorator.new(@drds.to_a, self)

    respond_with(decorator.value, options)
  end

  def show
    #TODO Fix this.  Gross.
    @drd = Drd.find(UUIDTools::UUID.parse(params[:id]))

    respond_with(@drd, options)
  end

  def create
    @drd = Drd.create!(drd_params)

    respond_with(@drd, options)
  end

  def activate
    @drd = get_drd
    @drd.activate!

    respond_with(@drd, options)
  end

  def deactivate
    @drd = get_drd
    @drd.deactivate!

    respond_with(@drd, options)
  end

  def destroy
    @drd = get_drd
    @drd.destroy!

    respond_with(@drd, options)
  end

  private

  # NB: Allowing a requester to directly manipulate options is not normal.  It is a convenience for testing.
  def options
    params.slice(*OPTIONS_KEYS).symbolize_keys
  end

  def filtering_params(params)
    params.slice(:status)
  end

  def drd_params
    params.require(:drd).permit(:name, :status, :kind, :leviathan_uuid, :leviathan_url)
  end

  def get_drd
    Drd.find(UUIDTools::UUID.parse(params[:id]))
  end

end
