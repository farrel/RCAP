require 'rcap'
require 'webmock/rspec'

def random_circle_hash
  { lattitude: rand(-180..180),
    longitude: rand(-90..90),
    radius: rand(50) }
end
