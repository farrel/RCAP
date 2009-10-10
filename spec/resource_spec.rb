require 'spec/spec_helper'

describe( CAP::Resource ) do
  context( 'on initialisation' ) do
    before( :each ) do
      @resource = CAP::Resource.new
    end

    it( 'should have no mime_type' ){ @resource.mime_type.should( be_nil )}    
    it( 'should have no size' ){ @resource.size.should( be_nil )}         
    it( 'should have no uri' ){ @resource.uri.should( be_nil )}          
    it( 'should have no deref_uri' ){ @resource.deref_uri.should( be_nil )}    
    it( 'should have no digest' ){ @resource.digest.should( be_nil )}       
    it( 'should have no resource_desc' ){ @resource.resource_desc.should( be_nil )}
  end

  describe( 'should not be valid if it' ) do
    before( :each ) do
      @resource = CAP::Resource.new( :resource_desc => 'Resource Description' )
      @resource.should( be_valid )
    end

    it( 'does not have a resource description (resource_desc)' ) do
      @resource.resource_desc = nil
      @resource.should_not( be_valid )
    end
  end
end
