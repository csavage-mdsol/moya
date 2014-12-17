# Helper methods
module MoyaTestHelper
  def conn
    @connection ||= Faraday.new(root_url)
  end

  def drds
    parse_hale(conn.get('/drds.hale_json', conditions: ["can_do_anything"]).body)
  end

  def get(url, params = {})
    conn.get(url, params)
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

  def parse_hale(body)
    Representors::HaleDeserializer.new(body).to_representor
  end

  def root_url
    "http://localhost:1234"
  end

  def get_transition_uri(representor, transition)
    "#{representor.transitions.find { |tran| tran.rel == transition}.uri }"
  end
end
