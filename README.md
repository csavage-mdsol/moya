# Moya

Moya is a gem intended to show basic API functionality for a Rails project using the [Crichton](https://github.com/mdsol/crichton) Gem as its API dispatcher.  It helps support automated and ad-hoc testing of hypermedia-related gems.

## API Objects
The API contains a resource called "DRDs" which is a collection of "DRD" objects. DRD stands for Diagnostic and Repair Drone.  These objects support basic CRUD operations.  Included is "leviathan" links, which represents linking to outside resources.  Currently these are fake links, however a future iteration will spin up a second service which serves these resources as well.

## Installation

Add this line to your application's Gemfile:

    gem 'moya'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install moya

## Usage

### Automated Hypermedia Testing
A common usage pattern for this gem will be including code like the following in your spec helper:
```ruby
require 'moya'

RAILS_PORT = 8080 # Set the port at which the service can be accessed

config.before(:suite) do
  old_handler = trap(:INT) { # Unix Signal Handler
    Process.kill(:INT, $moya_rails_pid) if $moya_rails_pid
    old_handler.call if old_handler.respond_to?(:call)
  }
  $moya_rails_pid = Moya.spawn_rails_process!(RAILS_PORT) # Capture the Pid so it will spin down when we're done
end

config.after(:suite) do # End the process when we're done
  Process.kill(:INT, $moya_rails_pid)
end
```

This code in a ``` before(:suite) ``` hook first captures the old behavior for handling INT
( the SIGINT signal is sent to a process by its controlling terminal when a user wishes to interrupt
the process), ensures that the process is killed, and then proceeds with the original behavior.  
The rails pid is returned by the call to ``` spawn_rails_process! ```, which spins up a non blocking
rails process using ``` Process.spawn ```.  The ``` after(:suite) ``` hook cleans up for
the ``` before(:suite) ```, terminating the background rails process.  The service will be live and
consumable between the execution of these two hooks.

### Ad-Hoc Hypermedia Testing

create file run.rb
```ruby
#!/usr/bin/env ruby
require 'moya'

RAILS_PORT = 8080

puts Moya.spawn_rails_process!(RAILS_PORT) # Prints PID of process

```

Then you can access the api via standard localhost requests.

## Contributing

1. Fork it ( https://github.com/[my-github-username]/crichton_test_service/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
