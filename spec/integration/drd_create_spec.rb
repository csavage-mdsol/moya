RSpec.describe Moya do
  context 'when the service is running' do
    describe '#create' do
      context 'when requesting hale json' do
        include_context 'shared drd hale context'

        it 'responds appropriately to a drd create call specifying only name and status' do
          response = post(create_url, { drd: {name: 'Pike', status: 'activated'} })

          expect(response.status).to eq(201)

          drd = parse_hale(response.body)
          self_url = hale_url_for("self", drd)
          response = get self_url
          expect(response.status).to eq(200)
          drd = parse_hale(response.body)
          expect(drd.properties['name']).to eq('Pike')
          expect(drd.properties['status']).to eq('activated')
        end

        it 'responds with an error when provided a name that is greater than 50 characters' do
          response = post create_url, { drd: {name: "a"*51, status: 'activated' } }
          expect(response.status).to eq(422)
          expect(parse_hale(response.body).properties.keys).to match_array(error_properties)
        end

        xit 'responds with an error when provided an unrecognized status' do
        end

        xit 'responds with an error when provided an unrecognized old status' do
        end

        xit 'responds appropriately to a drd create call specifying all permissible attributes' do
        end

        xit 'responds appropriately to a create call missing required attributes' do
        end

        xit 'responds appropraitely to a create call with unpermitted attributes' do
        end
      end
    end
  end
end
