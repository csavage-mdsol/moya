Dir["#{ENV['INITIALIZER_DIRECTORY']}/*.rb"].each {|file| require file } if ENV["INITIALIZER_DIRECTORY"]
