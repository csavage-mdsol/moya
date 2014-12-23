RSpec.describe Moya do

  #NB DO NOT add additional nested descibes or context blocks, else you will incur the overhead of
  # spinning the moya service up and down for each block.

  before(:all) do
    Process.kill(:INT, $moya_rails_pid) if $moya_rails_pid
    $moya_rails_pid = nil
  end

  after(:all) do
    old_handler = trap(:INT) {
      Process.kill(:INT, $moya_rails_pid) if $moya_rails_pid
    }

    $moya_rails_pid = Moya.spawn_rails_process!(RAILS_PORT)
  end

  it 'loads the rails environment' do
    expect { Rails }.to raise_error(NameError, "uninitialized constant Rails")
    Moya.initialize_rails!
    expect { Rails }.not_to raise_error
  end

  it 'executes the initialization code' do
    pid = Moya.spawn_rails_process!(1234, "#{SPEC_DIR}/fixtures" )
    expect(get('/').body).to eq("Alive!")
    Process.kill(:INT, pid)
  end
end
