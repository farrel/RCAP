require 'rcap'
require 'webmock/rspec'

def random_circle_hash
  { :lattitude => rand( 360 ) - 180,
    :longitude => rand( 180 ) - 90,
    :radius => rand( 50 ) }
end
