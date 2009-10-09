require 'spec/spec_helper'

describe( CAP::Polygon ) do
  describe( 'is not valid if it' ) do
    before( :each ) do
      @polygon = CAP::Polygon.new
      3.times do
        @polygon.points << CAP::Point.new( 0, 0 )
      end
      @polygon.should( be_valid )
    end

    it( 'does not have any points' ) do
      @polygon.points.clear
      @polygon.should_not( be_valid )
    end

    it( 'does not have a valid collection of points' ) do
      @polygon.points.first.lattitude = nil
      @polygon.should_not( be_valid )
    end
  end
end
