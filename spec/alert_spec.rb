require 'spec/spec_helper'

describe( CAP::Alert ) do
  context( 'on initialisation' ) do
    before( :each )  do
      @alert = CAP::Alert.new
    end

    it( 'should have a default identifier' ){ @alert.identifier.should_not( be_nil )}
    it( 'should not have a sender' ){ @alert.sender.should( be_nil )}
    it( 'should have a default sent time' ){ @alert.sent.should_not( be_nil )}
    it( 'should not have a status' ){ @alert.status.should( be_nil )}
    it( 'should not have a scope' ){ @alert.scope.should( be_nil )}
    it( 'should not have a source'){ @alert.source.should( be_nil )}
    it( 'should not have a restriction'){ @alert.restriction.should( be_nil )}
    it( 'should not have any addresses' ){ @alert.addresses.should( be_empty )}
    it( 'should not have a code' ){ @alert.code.should( be_nil )}
    it( 'should not have a note' ){ @alert.note.should( be_nil )}
    it( 'should not have any references' ){ @alert.references.should( be_empty )}
    it( 'should not have any incidents' ){ @alert.incidents.should( be_empty )}
    it( 'should not have any infos' ){ @alert.infos.should( be_empty )}
  end

  describe( 'is not valid if it' ) do
    before( :each ) do
      @alert = CAP::Alert.new( :sender => "cap@tempuri.org",
                              :status => CAP::Alert::STATUS_TEST,
                              :msg_type => CAP::Alert::MSG_TYPE_ALERT,
                              :scope => CAP::Alert::SCOPE_PUBLIC )
      @alert.should( be_valid )
    end

    it( 'does not have a identifier' ) do
      @alert.identifier = nil
      @alert.should_not( be_valid )
    end

    it( 'does not have a sender' ) do
      @alert.sender = nil
      @alert.should_not( be_valid )
    end

    it( 'does not have a sent time (sent)' ) do
      @alert.sent = nil
      @alert.should_not( be_valid )
    end

    it( 'does not have a status' ) do
      @alert.status = nil
      @alert.should_not( be_valid )
    end

    it( 'does not have a message type (msg_type)' ) do
      @alert.msg_type = nil
      @alert.should_not( be_valid )
    end

    it( 'does not have a scope' ) do
      @alert.scope = nil
      @alert.should_not( be_valid )
    end


    it( 'does not have a valid status' ) do
      @alert.status = 'incorrect value'
      @alert.should_not( be_valid )
    end

    it( 'does not have a valid message type msg_type' ) do
      @alert.msg_type = 'incorrect value'
      @alert.should_not( be_valid )
    end

    it( 'does not have a valid scope' ) do
      @alert.scope = 'incorrect value'
      @alert.should_not( be_valid )
    end


    context( 'has an info element and it' ) do
      it( 'is not valid' ) do
        @info = CAP::Info.new( :event => 'Info Event',
                              :categories => CAP::Info::CATEGORY_GEO,
                              :urgency => CAP::Info::URGENCY_IMMEDIATE,
                              :severity => CAP::Info::SEVERITY_EXTREME,
                              :certainty => CAP::Info::CERTAINTY_OBSERVED )
        @info.event = nil
        @alert.infos << @info
        @alert.should_not( be_valid )
      end
    end
  end
end
