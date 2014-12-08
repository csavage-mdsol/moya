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
    @drds = Drds.find(params[:search_term])
    respond_with(@drds, options)
  end

  def show
    @drd = Drd.find_by_uuid!(params[:id])
    respond_with(@drd, options)
  end

  private

  # NB: Allowing a requester to directly manipulate options is not normal.  It is a convenience for testing.
  def options
    params.slice(*OPTIONS_KEYS).symbolize_keys
  end

end
