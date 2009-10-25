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

		context( 'from XML' ) do
			before( :each ) do
				@original_area = CAP::Area.new( :area_desc => 'Area Description',
																			 :altitude => 100,
																			 :ceiling => 200,
																			 :circles => CAP::Circle.new( :point => CAP::Point.new( :lattitude => 0, :longitude => 0 ), :radius => 100 ),
																			 :geocodes => CAP::Geocode.new( :name => 'name', :value => 'value' ),
																			 :polygons => CAP::Polygon.new( :points => CAP::Point.new( :lattitude =>1, :longitude => 1 ))) 

				@alert = CAP::Alert.new( :infos => CAP::Info.new( :areas => @original_area ))
				@xml_string = @alert.to_xml
				@xml_document = REXML::Document.new( @xml_string )
				@area_xml_element = CAP.xpath_first( @xml_document, CAP::Area::XPATH )
				@area = CAP::Area.from_xml_element( @area_xml_element )
			end

			it( 'should parse the area_desc correctly' ) do
				@area.area_desc.should == @original_area.area_desc
			end

			it( 'should parse the altitude correctly' ) do
				@area.altitude.should == @original_area.altitude
			end

			it( 'should parse the ceiling correctly' ) do
				@area.ceiling.should == @original_area.ceiling
			end
			
			it( 'should parse the circles correctly' ) do
				@area.circles.should == @original_area.circles
			end

			it( 'should parse the geocodes correctly' ) do
				@area.geocodes.should == @original_area.geocodes
			end

			it( 'should parse the polygons correctly' ) do
				@area.polygons.should == @original_area.polygons
			end
		end
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
