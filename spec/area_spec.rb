require 'spec/spec_helper'

describe( CAP::Area ) do
	context( 'on initialisation' ) do
		before( :each ) do
			@area = CAP::Area.new
		end

		# Atomic
		it( 'should not have a area_desc' ){ @area.area_desc.should( be_nil )}
		it( 'should not have a altitude' ){ @area.altitude.should( be_nil )}
		it( 'should not have a ceiling' ){ @area.ceiling.should( be_nil )}
		
		# Group
		it( 'should have an empty polygons' ){ @area.polygons.should( be_empty )}
		it( 'should have an empty circles' ){ @area.circles.should( be_empty )}
		it( 'should have an empty geocodes' ){ @area.geocodes.should( be_empty )}
	end

  context( 'is not valid if' ) do
    before( :each ) do
      @area = CAP::Area.new( :area_desc => "Cape Town Metropole" )
      @area.should( be_valid )
    end

    it( 'does not have an area descrtiption (area_desc)') do
      @area.area_desc = nil
      @area.should_not( be_valid )
    end

    it( 'has a ceiling defined but no altitude' ) do
      @area.ceiling = 1
      @area.altitude = nil
      @area.should_not( be_valid )
    end

    context( 'it contains circles and it' ) do
      before( :each ) do
        @area.circles << CAP::Circle.new( :point => CAP::Point.new( :lattitude => 0, :longitude => 0 ), :radius => 1)
        @area.should( be_valid )
      end

      it( 'has an invalid circle' ) do
        @area.circles.first.point.lattitude = nil
        @area.should_not( be_valid )
      end
    end

    context( 'it contains polygons and it' ) do
      before( :each ) do
        @polygon = CAP::Polygon.new
        @polygon.points.push( CAP::Point.new( :lattitude => 0, :longitude => 0 ),
                             CAP::Point.new( :lattitude => 0, :longitude => 1 ),
                             CAP::Point.new( :lattitude => 1, :longitude => 0 ))
        @area.polygons << @polygon
        @area.should( be_valid )
      end

      it( 'has an invalid polygon' ) do
        @polygon.points.first.lattitude = nil
        @area.should_not( be_valid )
      end
    end

    context( 'it contains geocodes and it' ) do
      before( :each ) do
        @geocode = CAP::Geocode.new( :name => 'foo', :value => 'bar' )
        @area.geocodes << @geocode
        @area.should( be_valid )
      end

      it( 'has an invalid geocode' ) do
        @geocode.value = nil
        @area.should_not( be_valid )
      end
    end
  end
end
