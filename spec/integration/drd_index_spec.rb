RSpec.describe Moya do
  context 'When the service is running' do
    context 'when requesting hale json' do
      describe '#index' do
        let(:collection_transitions) { [ 'self',
                                         'search',
                                         'create',
                                         'items',
                                         'profile',
                                         'type',
                                         'help'
                                        ]  }

        it 'responds with a 200 status to a drd index call' do
          expect(get('/drds.hale_json').status).to eq(200)
        end

        it 'includes transitions when conditions are met' do
          response = get('/drds.hale_json', { conditions: ["can_create"] })
          expect(JSON.parse(response.body)["_links"]).to have_key("create")
        end

        it 'filters out available transitions for unmet conditions' do
          response = get('/drds.hale_json', { conditions: [] })
          expect(JSON.parse(response.body)["_links"]).to_not have_key("create")
        end

        it 'includes all appropriate properties for the collection' do
          expect(drds.properties.keys).to match_array(['total_count'])
        end

        it 'includs all appropriate transitions for the collection' do
          expect(drds.transitions.map{ |t| t.rel }.to_set).to match(collection_transitions.to_set)
        end

        it 'returns a collection of drds filtered by status' do
          search_url = hale_url_for('search', drds)
          response = get search_url, { status: 'activated' }
          expect(response.status).to eq(200)
          parse_hale(response.body).embedded['items'].each do |rep|
            expect(rep.properties['status']).to eq('activated')
          end
        end
      end
    end
  end
end
