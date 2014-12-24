RSpec.shared_context 'shared drd hale context' do
  let(:can_do_hash) { {conditions: ['can_do_anything']} }
  let(:create_url) { "#{get_transition_uri(drds, 'create')}.hale_json" }
  let(:drd_properties) { [ 'id',
                           'name',
                           'status',
                           'old_status',
                           'kind',
                           'size',
                           'leviathan_uuid',
                           'created_at',
                           'location',
                           'location_detail',
                           'destroyed_status'
                          ] }
  let(:error_properties) { ['details', 'error_code', 'http_status', 'stack_trace', 'title'] }
  let(:drd_hash) { { drd: { name: 'Pike',
                            status: 'activated',
                            old_status: 'activated',
                            kind: 'standard',
                            leviathan_uuid: 'd34c78bd-583c-4eff-a66c-cd9b047417b4',
                            leviathan_url: 'http://example.org/leviathan/d34c78bd-583c-4eff-a66c-cd9b047417b4'
                          }
                    }
                  }

end
