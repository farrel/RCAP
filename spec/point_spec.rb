require 'spec/spec_helper'

describe( CAP::Point ) do
  describe( 'is not valid if' ) do
    before( :each ) do
      @point = CAP::Point.new( :lattitude => 0, :longitude => 0 )
      @point.should( be_valid )
    end

    it( 'does not have a longitude defined' ) do
      @point.longitude = nil
      @point.should_not( be_valid )
    end

    it( 'does not have a valid longitude' ) do
      @point.longitude = CAP::Point::MAX_LONGITUDE + 1
      @point.should_not( be_valid )
      @point.longitude = CAP::Point::MIN_LONGITUDE - 1
      @point.should_not( be_valid )
    end

    it( 'does not have a lattitude defined' ) do
      @point.lattitude = nil
      @point.should_not( be_valid )
    end

    it( 'does not have a valid lattitude' ) do
      @point.lattitude = CAP::Point::MAX_LATTITUDE + 1
      @point.should_not( be_valid )
      @point.lattitude = CAP::Point::MIN_LATTITUDE - 1
      @point.should_not( be_valid )
    end
  end
end
