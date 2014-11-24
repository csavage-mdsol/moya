require 'faraday'
require 'crichton_test_service'

RSpec.describe CrichtonTestService do
  # NB: Do not use any additional nested context blocks unless you want to spin up a
  # rails process for each one.
  context "When the service is running" do
    before(:all) do
      old_handler = trap(:INT) {
        Process.kill(:INT, @rails_pid) if @rails_pid
        old_handler.call if old_handler.respond_to?(:call)
      }
      @rails_pid = CrichtonTestService.spawn_rails_process!(port = 1234)
    end
    after(:all) { Process.kill(:INT, @rails_pid) if @rails_pid }

    let(:conn) { Faraday.new(ROOT_URL) }

    # Start up the service, and ensure INT also kills the service
    it 'responds to root' do
      expect(conn.get('/').status).to eq(200)
    end

    it 'responds to an index call' do
      expect(conn.get('/drds.hale_json').status).to eq(200)
    end

    xit 'responds to a show call' do
    end

    xit 'responds to a create call' do
    end

    xit 'responds to an update call' do
    end

    xit 'responds to a destroy call' do
    end

    xit 'responds to an activate call' do
    end

    xit 'responds to a deactivate call' do
    end
  end

end
