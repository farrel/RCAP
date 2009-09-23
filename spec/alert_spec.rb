require 'spec/spec_helper'

describe( CAP::Alert ) do
  context( 'on initialization' ) do
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
end
