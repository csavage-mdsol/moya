# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).

5.times do |i|
  Drd.create!(
    name: "Pike#{i}",
    status: Random.rand(2) > 0 ? 'activated' : 'deactivated',
    kind: Random.rand(2) > 0 ? 'standard' : 'sentinel',
    leviathan_uuid: leviathan_uuid = SecureRandom.uuid,
    leviathan_url: "http://farscape.example.org/leviathan/#{leviathan_uuid}"
  )
end
