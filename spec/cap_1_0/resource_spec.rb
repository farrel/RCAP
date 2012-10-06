require 'spec_helper'

describe( RCAP::CAP_1_0::Resource ) do
  context( 'on initialisation' ) do
    before( :each ) do
      @resource = RCAP::CAP_1_0::Resource.new
    end

    it( 'should have no mime_type' ){     @resource.mime_type.should( be_nil )}
    it( 'should have no size' ){          @resource.size.should( be_nil )}
    it( 'should have no uri' ){           @resource.uri.should( be_nil )}
    it( 'should have no digest' ){        @resource.digest.should( be_nil )}
    it( 'should have no resource_desc' ){ @resource.resource_desc.should( be_nil )}

    context( 'from XML' ) do
      before( :each ) do
        @original_resource = RCAP::CAP_1_0::Resource.new do |resource|
          resource.resource_desc = "Image of incident"
          resource.uri           = "http://capetown.gov.za/cap/resources/image.png"
          resource.mime_type     = 'image/png'
          resource.size          = 20480
          resource.digest        = "2048"
        end

        @alert = RCAP::CAP_1_0::Alert.new
        @alert.add_info.resources << @original_resource
        @xml_string = @alert.to_xml
        @xml_document = REXML::Document.new( @xml_string )
        @info_element = RCAP.xpath_first( @xml_document.root, RCAP::CAP_1_0::Info::XPATH, RCAP::CAP_1_0::Alert::XMLNS )
        @resource_element = RCAP.xpath_first( @info_element, RCAP::CAP_1_0::Resource::XPATH, RCAP::CAP_1_0::Alert::XMLNS )
        @resource_element.should_not( be_nil )
        @resource = RCAP::CAP_1_0::Resource.from_xml_element( @resource_element )
      end

      it( 'should parse resource_desc correctly' ) do
        @resource.resource_desc.should == @original_resource.resource_desc
      end

      it( 'should parse uri correctly' ) do
        @resource.uri.should == @original_resource.uri
      end

      it( 'should parse mime_type correctly' ) do
        @resource.mime_type.should == @original_resource.mime_type
      end

      it( 'should parse size correctly' ) do
        @resource.size.should == @original_resource.size
      end

      it( 'should parse digest correctly' ) do
        @resource.digest.should == @original_resource.digest
      end
    end


    context( 'from a hash' ) do
      before( :each ) do
        @original_resource = RCAP::CAP_1_0::Resource.new do |resource|
          resource.resource_desc = "Image of incident"
          resource.uri           = "http://capetown.gov.za/cap/resources/image.png"
          resource.mime_type     = 'image/png'
          resource.size          = 20480
          resource.digest        = "2048"
        end

        @resource = RCAP::CAP_1_0::Resource.from_h( @original_resource.to_h )
      end

      it( 'should parse resource_desc correctly' ) do
        @resource.resource_desc.should == @original_resource.resource_desc
      end

      it( 'should parse uri correctly' ) do
        @resource.uri.should == @original_resource.uri
      end

      it( 'should parse mime_type correctly' ) do
        @resource.mime_type.should == @original_resource.mime_type
      end

      it( 'should parse size correctly' ) do
        @resource.size.should == @original_resource.size
      end

      it( 'should parse digest correctly' ) do
        @resource.digest.should == @original_resource.digest
      end
    end

  end

  context( 'when exported' ) do
    before( :each ) do
      @resource = RCAP::CAP_1_0::Resource.new do |resource|
        resource.resource_desc = "Image of incident"
        resource.uri           = "http://capetown.gov.za/cap/resources/image.png"
        resource.mime_type     = 'image/png'
        resource.size          = 20480
        resource.digest        = "2048"
      end
    end

    context( 'to a hash' ) do
      before( :each ) do
        @resource_hash = @resource.to_h
      end

      it( 'should set the resource description' ) do
        @resource_hash[ RCAP::CAP_1_0::Resource::RESOURCE_DESC_KEY ].should == @resource.resource_desc
      end

      it( 'should set the mime type' ) do
        @resource_hash[ RCAP::CAP_1_0::Resource::MIME_TYPE_KEY ].should == @resource.mime_type
      end

      it( 'should set the size' ) do
        @resource_hash[ RCAP::CAP_1_0::Resource::SIZE_KEY ].should == @resource.size
      end

      it( 'should set the URI' ) do
        @resource_hash[ RCAP::CAP_1_0::Resource::URI_KEY ].should == @resource.uri
      end

      it( 'should set the digest' ) do
        @resource_hash[ RCAP::CAP_1_0::Resource::DIGEST_KEY ].should == @resource.digest
      end
    end

    context( 'to xml' ) do
      it( 'should be successful' ) do
        lambda{ @resource_xml = @resource.to_xml }.should_not( raise_exception )
      end
    end
  end

  context( 'which is valid' ) do
    before( :each ) do
      @resource = RCAP::CAP_1_0::Resource.new do |resource|
        resource.resource_desc = 'Resource Description'
      end

      @resource.should( be_valid )
    end

    describe( 'should not be valid if it' ) do
      it( 'does not have a resource description (resource_desc)' ) do
        @resource.resource_desc = nil
        @resource.should_not( be_valid )
      end
    end
  end
end
