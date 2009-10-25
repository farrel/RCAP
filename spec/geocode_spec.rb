require 'spec/spec_helper'

describe( CAP::Geocode ) do
  context( 'when initialised' ) do
    context( 'from XML' ) do
      before( :each ) do
        @original_geocode = CAP::Geocode.new( :name => 'name', :value => 'value' )
        @alert = CAP::Alert.new( :infos => CAP::Info.new( :areas => CAP::Area.new( :geocodes => @original_geocode )))
        @xml_string = @alert.to_xml
        @xml_document = REXML::Document.new( @xml_string )
        @geocode_xml_element  = CAP.xpath_first( @xml_document, CAP::Geocode::XPATH )
        @geocode = CAP::Geocode.from_xml_element( @geocode_xml_element )
      end

      it( 'should parse the name correctly' ) do
        @geocode.name.should == @original_geocode.name
      end

      it( 'should parse the value correctly' ) do
        @geocode.value.should == @original_geocode.value
      end
    end
  end
end
