RSpec.describe Moya do
  describe '.initialize_rails!' do
    it 'loads the rails environment' do
      expect { Rails }.to raise_error(NameError, "uninitialized constant Rails")
      CrichtonTestService.initialize_rails!
      expect { Rails }.not_to raise_error
    end
  end
end
