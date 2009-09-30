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
end
