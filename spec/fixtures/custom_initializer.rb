require 'rack'

module Rack
  class FakeResponder
    def initialize(app)
      @app = app
    end

    def call(env)
      [200, {"ContentType" => "text/html"}, ["Alive!"]]
    end
  end
end

config = Moya::Application.config
# Crichton will hijack calls to root if you don't insert yourself above it
config.middleware.insert_after Rack::Lock, Rack::FakeResponder
