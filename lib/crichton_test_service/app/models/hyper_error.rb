require 'crichton/tools/base_errors'

class HyperError < Crichton::Tools::BaseErrors
  include Crichton::Representor::State
  represents :hyper_error

  def describes_url
    controller.request.path
  end
end
