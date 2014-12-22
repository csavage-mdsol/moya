require 'crichton/tools/base_errors'

class HyperError < Crichton::Tools::BaseErrors
  include Crichton::Representor::State
  represents :hyper_error

  def initialize(data)
    super(data)
  end

  def describes_url
    controller.request.original_url
  end
end
