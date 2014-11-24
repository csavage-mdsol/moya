# CrichtonTestService

-TODO: Write a gem description

## Installation

Add this line to your application's Gemfile:

    gem 'crichton_test_service'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install crichton_test_service

## Usage

A common usage pattern for this gem will be including code like the following in your spec helper:
```ruby
config.before(:suite) do
  old_handler = trap(:INT) {
    Process.kill(:INT, $crichton_test_service_rails_pid) if $crichton_test_service_rails_pid
    old_handler.call if old_handler.respond_to?(:call)
  }
  WebMock.disable!
  $crichton_test_service_rails_pid = CrichtonTestService.spawn_rails_process!(RAILS_PORT)
end

config.after(:suite) do
  Process.kill(:INT, $crichton_test_service_rails_pid)
end
```
This code in a ``` before(:suite) ``` hook first captures the old behavior for handling INT
( the SIGINT signal is sent to a process by its controlling terminal when a user wishes to interrupt
the process), ensures that the process is killed, and then proceeds with the original behavior.  
The rails pid is returned by the call to ``` spawn_rails_process! ```, which spins up a non blocking
rails process using ``` Process.spawn ```.  The ``` after(:suite) ``` hook cleans up for
the ``` before(:suite) ```, terminating the background rails process.  The service will be live and
consumable between the execution of these two hooks.


## Contributing

1. Fork it ( https://github.com/[my-github-username]/crichton_test_service/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
