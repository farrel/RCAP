require 'spec_helper'

describe( RCAP::Area ) do
	context( 'on initialisation' ) do
		before( :each ) do
			@area = RCAP::Area.new
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
				@original_area = RCAP::Area.new( :area_desc => 'Area Description',
																			 :altitude => 100,
																			 :ceiling => 200,
																			 :circles => RCAP::Circle.new( :point => RCAP::Point.new( :lattitude => 0, :longitude => 0 ), :radius => 100 ),
																			 :geocodes => RCAP::Geocode.new( :name => 'name', :value => 'value' ),
																			 :polygons => RCAP::Polygon.new( :points => RCAP::Point.new( :lattitude =>1, :longitude => 1 ))) 

				@alert = RCAP::Alert.new( :infos => RCAP::Info.new( :areas => @original_area ))
				@xml_string = @alert.to_xml
				@xml_document = REXML::Document.new( @xml_string )
				@info_xml_element = RCAP.xpath_first( @xml_document.root, RCAP::Info::XPATH )
				@area_xml_element = RCAP.xpath_first( @info_xml_element, RCAP::Area::XPATH )
				@area = RCAP::Area.from_xml_element( @area_xml_element )
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

  context( 'when exported' ) do
    before( :each ) do
      @area = RCAP::Area.new( :area_desc => 'Area Description',
                             :altitude => 100,
                             :ceiling => 200,
                             :circles => RCAP::Circle.new( :point => RCAP::Point.new( :lattitude => 0, :longitude => 0 ), :radius => 100 ),
                             :geocodes => RCAP::Geocode.new( :name => 'name', :value => 'value' ),
                             :polygons => RCAP::Polygon.new( :points => RCAP::Point.new( :lattitude =>1, :longitude => 1 ))) 
    end
    context( 'to a hash' ) do
      before( :each ) do
        @area_hash = @area.to_h
      end

      it( 'should export the area description correctly' ) do
        @area_hash[ :area_desc ].should == @area.area_desc 
      end

      it( 'should export the altitude correctly' ) do
        @area_hash[ :altitude ].should == @area.altitude 
      end

      it( 'should set the ceiling correctly' ) do
        @area_hash[ :ceiling ].should == @area.ceiling
      end

      it( 'should export the circles correctly' ) do
        @area_hash[ :circles ].should == @area.circles.map{ |circle| circle.to_h }
      end

      it( 'should export the geocodes correctly' ) do
        @area_hash[ :geocodes ].should == @area.geocodes.map{ |geocode| geocode.to_h }
      end

      it( 'should export the polygons correctly' ) do
        @area_hash[ :polygons ].should == @area.polygons.map{ |polygon| polygon.to_h }
      end
    end
  end

  context( 'is not valid if' ) do
    before( :each ) do
      @area = RCAP::Area.new( :area_desc => "Cape Town Metropole" )
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
        @area.circles << RCAP::Circle.new( :point => RCAP::Point.new( :lattitude => 0, :longitude => 0 ), :radius => 1)
        @area.should( be_valid )
      end

      it( 'has an invalid circle' ) do
        @area.circles.first.point.lattitude = nil
        @area.should_not( be_valid )
      end
    end

    context( 'it contains polygons and it' ) do
      before( :each ) do
        @polygon = RCAP::Polygon.new
        @polygon.points.push( RCAP::Point.new( :lattitude => 0, :longitude => 0 ),
                             RCAP::Point.new( :lattitude => 0, :longitude => 1 ),
                             RCAP::Point.new( :lattitude => 1, :longitude => 0 ))
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
        @geocode = RCAP::Geocode.new( :name => 'foo', :value => 'bar' )
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
