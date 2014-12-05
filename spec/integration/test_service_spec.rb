require 'faraday'
require 'json'
require 'crichton_test_service'
require 'representors'

RSpec.describe CrichtonTestService do
  # NB: Do not use any additional nested context blocks unless you want to spin up a
  # rails process for each one.
  let(:conn) { Faraday.new(ROOT_URL) }

  context "When the service is running" do
    context "When requesting hale json" do
      before(:all) do
        old_handler = trap(:INT) {
          Process.kill(:INT, @rails_pid) if @rails_pid
          old_handler.call if old_handler.respond_to?(:call)
        }
        @rails_pid = CrichtonTestService.spawn_rails_process!(port = 1234)
      end
      after(:all) { Process.kill(:INT, @rails_pid) if @rails_pid }

      let(:conn) { Faraday.new(ROOT_URL) }
      let(:drds) do
        response_body = conn.get('/drds.hale_json', conditions: ["can_do_anything"]).body
        Representors::HaleDeserializer.new(response_body).to_representor
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

      it 'responds to a show call' do
        show_url = drds.transitions.find { |tran| tran.rel == "items" }.uri
        expect(conn.get("#{show_url}.hale_json").status).to eq(200)
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

  context 'when provided an initializer directory' do
    it 'executes the initialization code' do
      pid = CrichtonTestService.spawn_rails_process!(1234, "#{SPEC_DIR}/fixtures" )
      expect(conn.get('/').body).to eq("Alive!")
      Process.kill(:INT, pid)
    end
  end
end
