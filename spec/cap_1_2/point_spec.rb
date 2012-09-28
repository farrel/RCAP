require 'spec_helper'

describe( RCAP::CAP_1_2::Point ) do
  before( :each ) do
    @point_constructor = lambda do |point|
      point.lattitude = 0
      point.longitude = 0
    end
  end

  describe( 'is not valid if' ) do
    before( :each ) do
      @point = RCAP::CAP_1_2::Point.new( &@point_constructor )
      @point.should( be_valid )
    end

    it( 'does not have a longitude defined' ) do
      @point.longitude = nil
      @point.should_not( be_valid )
    end

    it( 'does not have a valid longitude' ) do
      @point.longitude = RCAP::CAP_1_2::Point::MAX_LONGITUDE + 1
      @point.should_not( be_valid )
      @point.longitude = RCAP::CAP_1_2::Point::MIN_LONGITUDE - 1
      @point.should_not( be_valid )
    end

    it( 'does not have a lattitude defined' ) do
      @point.lattitude = nil
      @point.should_not( be_valid )
    end

    it( 'does not have a valid lattitude' ) do
      @point.lattitude = RCAP::CAP_1_2::Point::MAX_LATTITUDE + 1
      @point.should_not( be_valid )
      @point.lattitude = RCAP::CAP_1_2::Point::MIN_LATTITUDE - 1
      @point.should_not( be_valid )
    end
  end

  context( 'when exported' ) do
    before( :each ) do
      @point = RCAP::CAP_1_2::Point.new( &@point_constructor )
    end

    context( 'to hash' ) do
      it( 'should export correctly' ) do
        @point.to_h.should == { RCAP::CAP_1_2::Point::LATTITUDE_KEY => 0, RCAP::CAP_1_2::Point::LONGITUDE_KEY => 0 }
      end
    end
  end
end
