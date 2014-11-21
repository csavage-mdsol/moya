require "crichton_test_service/version"

module CrichtonTestService

  # Uses Process.spawn to setup and spin up the crichton demo service rails server
  # Waits
  def self.spawn_rails_process!(port = 3000)
    rails_root = File.dirname(__FILE__) << '/crichton_test_service'
    Dir.chdir(rails_root) { system('bundle exec rake setup') }
    pid = Process.spawn("bundle exec rails server --port #{port}", chdir: "#{rails_root}")
    wait_for_response!("http://localhost:#{port}")
    pid
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
      retry if (i += 1)  < 30
    end
  end
end
