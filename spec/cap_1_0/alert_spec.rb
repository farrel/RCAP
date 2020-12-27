require 'spec_helper'

describe(RCAP::CAP_1_0::Alert) do
  context('on initialisation') do
    before(:each) do
      @alert = RCAP::CAP_1_0::Alert.new

      @original_alert = RCAP::CAP_1_0::Alert.new do |alert|
        alert.sender      = 'Sender'
        alert.sent        = DateTime.now
        alert.status      = RCAP::CAP_1_0::Alert::STATUS_TEST
        alert.scope       = RCAP::CAP_1_0::Alert::SCOPE_PUBLIC
        alert.source      = 'Source'
        alert.restriction = 'No Restriction'
        ['Address 1', 'Address 2'].each do |address|
          alert.addresses << address
        end
        %w[Code1 Code2].each do |code|
          alert.codes << code
        end
        alert.note = 'Note'
        %w[Sender1 Sender2].each do |sender|
          a = RCAP::CAP_1_0::Alert.new do |a|
            a.sender = sender
          end
          alert.references << a.to_reference
        end
        %w[Incident1 Incident2].each do |incident|
          alert.incidents << incident
        end
        2.times { alert.add_info }
      end
    end

    it('should have a identifier') { @alert.identifier.should_not(be_nil) }
    it('should not have a sender') { @alert.sender.should(be_nil) }
    it('should not have a sent time') { @alert.sent.should(be_nil) }
    it('should not have a status') { @alert.status.should(be_nil) }
    it('should not have a scope') { @alert.scope.should(be_nil) }
    it('should not have a source') { @alert.source.should(be_nil) }
    it('should not have a restriction') { @alert.restriction.should(be_nil) }
    it('should not have any addresses') { @alert.addresses.should(be_empty) }
    it('should not have any codes') { @alert.codes.should(be_empty) }
    it('should not have a note') { @alert.note.should(be_nil) }
    it('should not have any references') { @alert.references.should(be_empty) }
    it('should not have any incidents') { @alert.incidents.should(be_empty) }
    it('should not have any infos') { @alert.infos.should(be_empty) }

    shared_examples_for('a successfully parsed CAP 1.0 alert') do
      it('should parse identifier correctly') { @alert.identifier.should  == @original_alert.identifier }
      it('should parse sender correctly')     { @alert.sender.should      == @original_alert.sender }
      it('should parse sent correctly')       { @alert.sent.should(be_within(1).of(@original_alert.sent)) }
      it('should parse status correctly')     { @alert.status.should      == @original_alert.status }
      it('should parse msg_type correctly')   { @alert.msg_type.should    == @original_alert.msg_type }
      it('should parse source correctly')     { @alert.source.should      == @original_alert.source }
      it('should parse scope correctly')      { @alert.scope.should       == @original_alert.scope }
      it('should parse restriction correctly') { @alert.restriction.should == @original_alert.restriction }
      it('should parse addresses correctly')  { @alert.addresses.should   == @original_alert.addresses }
      it('should parse code correctly')       { @alert.codes.should       == @original_alert.codes }
      it('should parse note correctly')       { @alert.note.should        == @original_alert.note }
      it('should parse references correctly') { @alert.references.should  == @original_alert.references }
      it('should parse incidents correctly')  { @alert.incidents.should   == @original_alert.incidents }
      it('should parse infos correctly') do
        @alert.infos.size.should == @original_alert.infos.size
        @alert.infos.each { |info| info.class.should == RCAP::CAP_1_0::Info }
      end
    end

    context('from XML') do
      before(:each) do
        @xml_string = @original_alert.to_xml
        @xml_document = REXML::Document.new(@xml_string)
        @alert_element = @xml_document.root
        @alert = RCAP::CAP_1_0::Alert.from_xml_element(@alert_element)
      end

      it_should_behave_like('a successfully parsed CAP 1.0 alert')
    end

    context('from YAML') do
      before(:each) do
        @yaml_string = @original_alert.to_yaml
        @alert = RCAP::CAP_1_0::Alert.from_yaml(@yaml_string)
      end

      it_should_behave_like('a successfully parsed CAP 1.0 alert')
    end

    context('from a hash') do
      before(:each) do
        @alert = RCAP::CAP_1_0::Alert.from_h(@original_alert.to_h)
      end

      it_should_behave_like('a successfully parsed CAP 1.0 alert')
    end

    context('from JSON') do
      before(:each) do
        @alert = RCAP::CAP_1_0::Alert.from_json(@original_alert.to_json)
      end

      it_should_behave_like('a successfully parsed CAP 1.0 alert')
    end
  end

  describe('is not valid if it') do
    before(:each) do
      @alert = RCAP::CAP_1_0::Alert.new do |alert|
        alert.identifier = 'Identifier'
        alert.sender     = 'cap@tempuri.org'
        alert.sent       = DateTime.now
        alert.status     = RCAP::CAP_1_0::Alert::STATUS_TEST
        alert.msg_type   = RCAP::CAP_1_0::Alert::MSG_TYPE_ALERT
        alert.scope      = RCAP::CAP_1_0::Alert::SCOPE_PUBLIC
      end
      @alert.should(be_valid)
    end

    it('does not have a identifier') do
      @alert.identifier = nil
      @alert.should_not(be_valid)
    end

    it('does not have a sender') do
      @alert.sender = nil
      @alert.should_not(be_valid)
    end

    it('does not have a sent time (sent)') do
      @alert.sent = nil
      @alert.should_not(be_valid)
    end

    it('does not have a status') do
      @alert.status = nil
      @alert.should_not(be_valid)
    end

    it('does not have a message type (msg_type)') do
      @alert.msg_type = nil
      @alert.should_not(be_valid)
    end

    it('does not have a scope') do
      @alert.scope = nil
      @alert.should_not(be_valid)
    end

    it('does not have a valid status') do
      @alert.status = 'incorrect value'
      @alert.should_not(be_valid)
    end

    it('does not have a valid message type msg_type') do
      @alert.msg_type = 'incorrect value'
      @alert.should_not(be_valid)
    end

    it('does not have a valid scope') do
      @alert.scope = 'incorrect value'
      @alert.should_not(be_valid)
    end

    context('has an info element and it') do
      it('is not valid') do
        @info = @alert.add_info do |info|
          info.event     = 'Info Event'
          info.urgency   = RCAP::CAP_1_0::Info::URGENCY_IMMEDIATE
          info.severity  = RCAP::CAP_1_0::Info::SEVERITY_EXTREME
          info.certainty = RCAP::CAP_1_0::Info::CERTAINTY_VERY_LIKELY
        end
        @info.categories << RCAP::CAP_1_0::Info::CATEGORY_GEO
        @info.event = nil

        @info.should_not(be_valid)
        @alert.should_not(be_valid)
      end
    end
  end

  describe('instance methods') do
    before(:each) do
      @alert = RCAP::CAP_1_0::Alert.new
    end

    describe('#add_info') do
      before(:each) do
        @info = @alert.add_info do |info|
          info.urgency = 'urgent'
        end

        @info.urgency.should == 'urgent'
      end

      it('should return a CAP 1.0 Info object') do
        @info.class.should == RCAP::CAP_1_0::Info
      end

      it('should add an Info object to the infos array') do
        @alert.infos.size.should == 1
      end
    end
  end
end
