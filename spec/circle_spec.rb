require 'spec/spec_helper'

describe( CAP::Circle ) do
  describe( 'should not be valid if' ) do
    before( :each ) do
      @circle = CAP::Circle.new( CAP::Point.new( 0, 0 ), 1 )
      @circle.should( be_valid )
    end

    it( 'does not have a point defined' ) do
      @circle.point = nil
      @circle.should_not( be_valid )
    end
    
    it( 'does not have a valid point' ) do
      @circle.point.longitude = nil
      @circle.should_not( be_valid )
    end
    it( 'does not have a radius defined' ) do
      @circle.radius = nil
      @circle.should_not( be_valid )
    end

    it( 'does not have a numeric radius' ) do
      @circle.radius = "not a number"
      @circle.should_not( be_valid )
    end

    it( 'does not have a positive radius' ) do
      @circle.radius = -1
      @circle.should_not( be_valid )
    end
  end
end
