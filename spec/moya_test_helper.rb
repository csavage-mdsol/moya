require 'representors'
require 'faraday'

# Helper methods
module MoyaTestHelper
  def conn
    @connection ||= Faraday.new(root_url)
  end

  # Return the representor of the drds collection entry point, with the conditions can_do_anything
  def drds
    parse_hale(conn.get('/drds.hale_json', conditions: ["can_do_anything"]).body)
  end

  def get(url, params = {}, headers = {})
    conn.get(url, params) do |req|
      headers.each do |k,v|
        req.headers[k] = v
      end
    end
  end

  def put(url, hash_body = {})
    conn.put do |req|
      req.url url
      req.body = hash_body
    end
  end

  def post(url, hash_body = {})
    conn.post do |req|
      req.url url
      req.body = hash_body
    end
  end

  def delete(url)
    conn.delete(url)
  end

  # Return the Representor for the provided hale body
  def parse_hale(body)
    Representors::HaleDeserializer.new(body).to_representor
  end

  def root_url
    "http://localhost:1234"
  end

  # Given a representor and a transition, return the uri of that transition
  def get_transition_uri(representor, transition)
    "#{representor.transitions.find { |tran| tran.rel == transition}.uri }"
  end

  def hale_url_for(transition, representor)
    "#{get_transition_uri(representor, transition)}.hale_json"
  end
end
