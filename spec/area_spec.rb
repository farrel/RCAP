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

  context( 'is valid' ) do
    before( :each ) do
      @area = CAP::Area.new( :area_desc => "Cape Town Metropole" )
    end
  end
end
