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
    it( 'should have no severity' ){ @info.severity.should( be_nil )}
    it( 'should have no certainty' ){ @info.certainty.should( be_nil )}
    it( 'should have no audience' ){ @info.audience.should( be_nil )}
    it( 'should have no event_codes' ){ @info.event_codes.should( be_empty )}
    it( 'should have no effective datetime' ){ @info.effective.should( be_nil )}
    it( 'should have no onset datetime' ){ @info.onset.should( be_nil )}
    it( 'should have no expires datetime' ){ @info.expires.should( be_nil )}
    it( 'should have no sender name ' ){ @info.sender_name.should( be_nil )}
    it( 'should have no headline' ){ @info.headline.should( be_nil )}
    it( 'should have no description' ){ @info.description.should( be_nil )}
    it( 'should have no instruction' ){ @info.instruction.should( be_nil )}
    it( 'should have no web' ){ @info.web.should( be_nil )}
    it( 'should have no contact' ){ @info.contact.should( be_nil )}
    it( 'should have no parameters' ){ @info.parameters.should( be_empty )}
  end
end
