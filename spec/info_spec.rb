require 'spec/spec_helper'

describe( CAP::Info ) do
  context( 'on initialisation' ) do
    before( :each ) do
      @info = CAP::Info.new
    end

    it( 'should have a default language of en-US' ){ @info.language.should == 'en-US' }
    it( 'should have no categories' ){ @info.categories.should( be_empty )}
    it( 'should have no event' ){ @info.event.should( be_nil )}
    it( 'should have no response types' ){ @info.response_types.should( be_empty )}
    it( 'should have no urgency' ){ @info.urgency.should( be_nil )}
  end
end
