require 'faraday'
require 'json'
require 'crichton_test_service'

RSpec.describe CrichtonTestService do
  # NB: Do not use any additional nested context blocks unless you want to spin up a
  # rails process for each one.
  context "When the service is running" do
    #Start up the service and ensure INT kills the service
    before(:all) do
      old_handler = trap(:INT) {
        Process.kill(:INT, @rails_pid) if @rails_pid
        old_handler.call if old_handler.respond_to?(:call)
      }
      @rails_pid = CrichtonTestService.spawn_rails_process!(port = 1234)
    end
    after(:all) { Process.kill(:INT, @rails_pid) if @rails_pid }

    let(:conn) { Faraday.new(ROOT_URL) }

    # We do this here because with an app already running, the method will return
    # false instead of actually spinning up a rails app.
    it 'spins up a rails app' do
      env_vars = { "ALPS_BASE_URI"=>"http://localhost:3000/alps",
                   "DEPLOYMENT_BASE_URI"=>"http://localhost:3000",
                   "DISCOVERY_BASE_URI"=>"http://localhost:3000",
                   "CRICHTON_PROXY_BASE_URI"=>"http://localhost:3000/crichton"
                  }
      expect(CrichtonTestService).to receive('system').with(env_vars, 'bundle exec rake setup')
      expect(CrichtonTestService).to receive('system').with(env_vars, 'bundle exec rails server --port 3000')
      CrichtonTestService.spin_up_rails_app!
    end

    it 'responds to root' do
      expect(conn.get('/').status).to eq(200)
    end

    it 'responds to an index call' do
      expect(conn.get('/drds.hale_json').status).to eq(200)
    end

    it 'includes transitions when conditions are met' do
      response = conn.get('/drds.hale_json', { conditions: ["can_create"] })
      expect(JSON.parse(response.body)["_links"]).to have_key("create")
    end

    it 'filters out available transitions for unmet conditions' do
      response = conn.get('/drds.hale_json', { conditions: [] })
      expect(JSON.parse(response.body)["_links"]).to_not have_key("create")
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
