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
          error = parse_hale(response.body)
          expect(response.status).to eq(422)
          expect(error.properties.keys).to match_array(error_properties)
          expect(error.properties['title']).to eq("ActiveRecord::RecordInvalid")
        end

        it 'responds with an error when provided an unrecognized status' do
          response = post create_url, { drd: {name: 'Pike', status: 'bad status'} }
          error = parse_hale(response.body)
          expect(response.status).to eq(422)
          expect(error.properties.keys).to match_array(error_properties)
          expect(error.properties['title']).to eq('ActiveRecord::RecordInvalid')
        end

        it 'responds with an error when provided an unrecognized old status' do
          response = post create_url, { drd: {name: 'Pike', status: 'activated', old_status: 'bad status'} }
          error = parse_hale(response.body)
          expect(response.status).to eq(422)
          expect(error.properties.keys).to match_array(error_properties)
          expect(error.properties['title']).to eq('ActiveRecord::RecordInvalid')
        end

        it 'responds appropriately to a drd create call specifying all permissible attributes' do
          response = post create_url, drd_hash.merge(can_do_hash)
          expect(response.status).to eq(201)

          drd = parse_hale(response.body)
          self_url = hale_url_for("self",drd)
          expect(get(self_url).status).to eq(200)

          # clean up after ourselves
          delete hale_url_for("delete", drd)
        end

        it 'responds appropriately to a create call missing a name attribute' do
          response = post create_url, { drd: {status: 'activated'} }
          error = parse_hale(response.body)
          expect(response.status).to eq(422)
          expect(error.properties.keys).to match_array(error_properties)
          expect(error.properties['title']).to eq('ActiveRecord::RecordInvalid')
        end

        it 'responds appropriately to a create call missing a status attribute' do
          response = post create_url, { drd: {name: 'Pike'} }
          error = parse_hale(response.body)
          expect(response.status).to eq(422)
          expect(error.properties.keys).to match_array(error_properties)
          expect(error.properties['title']).to eq('ActiveRecord::RecordInvalid')
        end
      end
    end
  end
end
