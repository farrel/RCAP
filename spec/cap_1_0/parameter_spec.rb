require 'spec_helper'

describe( RCAP::CAP_1_0::Parameter ) do
  context( 'when initialised' ) do
    context( 'from XML' ) do
      before( :each ) do
        @original_parameter = RCAP::CAP_1_0::Parameter.new( :name => 'name', :value => 'value' )
        @alert = RCAP::CAP_1_0::Alert.new( :infos => RCAP::CAP_1_0::Info.new( :parameters => @original_parameter ))
        @xml_string = @alert.to_xml
        @xml_document = REXML::Document.new( @xml_string )
        @info_xml_element = RCAP.xpath_first( @xml_document.root, RCAP::CAP_1_0::Info::XPATH, RCAP::CAP_1_0::Alert::XMLNS )
        @parameter_xml_element = RCAP.xpath_first( @info_xml_element, RCAP::CAP_1_0::Parameter::XPATH, RCAP::CAP_1_0::Alert::XMLNS )
        @parameter = RCAP::CAP_1_0::Parameter.from_xml_element( @parameter_xml_element )
      end

      it( 'should parse into the correct class' ) do
        @parameter.class.should == RCAP::CAP_1_0::Parameter
      end

      it( 'should parse the name correctly' ) do
        @parameter.name.should == @original_parameter.name
      end

      it( 'should parse the value correctly' ) do
        @parameter.value.should == @original_parameter.value
      end
    end
  end

  context( 'when exported' ) do
    before( :each ) do
      @parameter = RCAP::CAP_1_0::Parameter.new( :name => 'name', :value => 'value' )
    end

    context( 'to a hash' ) do
      it( 'should export correctly' ) do
        @parameter.to_h.should == { 'name' => 'value' }
      end
    end
  end

  describe( '.parse_parameter' ) do
    it( 'should parse the content correctly' ) do
      RCAP::CAP_1_0::Parameter.parse_parameter( "name=value" ).should == { :name => 'name', :value => 'value' }
    end
  end

  describe( '.to_xml_element' ) do
    before( :each ) do
      @parameter = RCAP::CAP_1_0::Parameter.new( :name => 'name', :value => 'value' )
    end

    it( 'should generate an XML element correctly' ) do
      @parameter.to_xml_element.text.should == 'name=value'
    end
  end

  describe( '.from_xml_element' ) do
    before( :each ) do
      @parameter = RCAP::CAP_1_0::Parameter.new( :name => 'name', :value => 'value' )
    end

    it( 'should initialise correctly' ) do
      parameter = RCAP::CAP_1_0::Parameter.from_xml_element( @parameter.to_xml_element )
      parameter.name.should == @parameter.name
      parameter.value.should == @parameter.value
    end
  end
end
