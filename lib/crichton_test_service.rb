require "crichton_test_service/version"

module CrichtonTestService


  # Initialize rails in the development environment.
  def self.initialize_rails!
    require File.dirname(__FILE__) << "/crichton_test_service/config/environment"
  end

  # Uses Process.spawn to setup and spin up the crichton demo service rails server
  def self.spawn_rails_process!(port = 3000)
    rails_root = File.dirname(__FILE__) << '/crichton_test_service'
    Dir.chdir(rails_root) { system(env_vars_hash(port), 'bundle exec rake setup') }
    @pid = Process.spawn("bundle exec rails server --port #{port}", chdir: "#{rails_root}")
    wait_for_response!("http://localhost:#{port}")
  ensure
    return @pid
  end

  private

  # Waits up to 30 seconds for a response to root from the passed in url
  def self.wait_for_response!(url)
    connection = Faraday.new(url)
    # Faraday retries are not behaving as expected, so we manually do so here.
    i = 0
    begin
      connection.get('/')
    rescue Faraday::Error::ConnectionFailed
      sleep 1
      (i += 1)  < 30 ? retry : raise
    end
  end

  def self.env_vars_hash(port)
    localhost = "http://localhost:#{port}"
    {
      "ALPS_BASE_URI" => "#{localhost}/alps",
      "DEPLOYMENT_BASE_URI" => localhost,
      "DISCOVERY_BASE_URI" => localhost,
      "CRICHTON_PROXY_BASE_URI" => "#{localhost}/crichton"
    }
  end
end
