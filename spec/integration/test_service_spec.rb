RSpec.describe Moya do
  # NB: Do not use any additional nested context blocks unless you want to spin up a
  # rails process for each one.
  context "When the service is running" do
    context "When requesting hale json" do
      include_context 'shared drd hale context'

      it 'responds appropriately to root' do
        expect(get('/').status).to eq(200)
      end


      it 'responds appropriately to a drd show call' do
        show_url = hale_url_for("self", drds.embedded["items"].sample)
        expect(get(show_url).status).to eq(200)
      end

      it 'returns the appropriate attributes for a drd show call' do
        show_url = hale_url_for("self", drds.embedded["items"].sample)
        drd = parse_hale(get(show_url).body)
        expect(drd.properties.keys).to match_array(drd_properties)
      end

      it 'returns an appropriate 404 response for an unkown drd' do
        show_url = hale_url_for("self", drds.embedded["items"].sample)
        bad_show_url = "#{show_url[0...-46]}#{SecureRandom.uuid}.hale_json"

        response = get bad_show_url
        expect(response.status).to eq(404)
        expect(parse_hale(response.body).properties.keys).to match_array(error_properties)
      end

      it 'responds appropirately to an update call with all permissible attributes' do
        # Create a drd
        response = post create_url, drd_hash.merge(can_do_hash)
        drd = parse_hale(response.body)

        # Update the drd with all permissible attributes
        expect(drd.properties['name']).to eq('Pike')
        properties = { 'status' => 'deactivated',
                       'old_status' => 'activated',
                       'kind' => 'sentinel',
                       'size' => 'medium',
                       'location' => 'Mars',
                       'location_detail' => 'Olympus Mons',
                       'destroyed_status' => true
                     }
        response = put hale_url_for("update", drd), properties
        expect(response.status).to eq(303)

        # Check that it is really updated
        response = get hale_url_for("self", drd)
        drd = parse_hale(response.body)

        expect(drd.properties.slice(*properties.keys)).to eq(properties)
      end

      it 'responds to a destroy call' do
        # Create a drd
        response = post create_url, drd_hash

        #Make sure it is there
        self_url = hale_url_for("self", parse_hale(response.body))
        response = get self_url, can_do_hash
        expect(response.status).to eq(200)

        #blow it up
        destroy_url = hale_url_for("delete", parse_hale(response.body))
        response = delete destroy_url
        expect(response.status).to eq(204)

        # make sure it is gone
        response = get self_url
        expect(response.status).to eq(404)
      end

      it 'responds idempotently to an activate call' do
        # Create deactivated drd
        req_body = {name: 'deactivated drd', status: 'deactivated', kind: 'standard'}.merge(can_do_hash)
        response = post(create_url, req_body)

        # Get the activate URL
        drd = parse_hale(response.body)
        activate_url = "#{get_transition_uri(drd, "activate")}.hale_json"

        # Activate twice.
        put activate_url
        response = put activate_url
        expect(response.status).to eq(204)

        # Verify
        response = get hale_url_for("self", drd), can_do_hash
        expect(parse_hale(response.body).properties['status']).to eq('activated')

        # Destroy our drd
        delete hale_url_for("delete", drd)
      end

      it 'responds idempotently to a deactivate call' do
        # Create deactivated drd
        req_body = {name: 'activated drd', status: 'activated', kind: 'standard'}.merge(can_do_hash)
        response = post(create_url, req_body)

        # Get the activate URL
        drd = parse_hale(response.body)
        deactivate_url = hale_url_for("deactivate", drd)

        # Deactivate twice.
        put deactivate_url
        response = put deactivate_url
        expect(response.status).to eq(204)

        # Verify
        response = get hale_url_for("self", drd), can_do_hash
        expect(parse_hale(response.body).properties['status']).to eq('deactivated')

        # Destroy our drd
        delete hale_url_for("delete", drd)
      end
    end
  end
end
