require 'spec_helper'

describe(RCAP::Info) do
  describe('initialising') do
    context('a CAP 1.2 info') do
      let(:alert) do
        RCAP::CAP_1_2::Alert.new
      end

      let(:original_info) do
        RCAP::CAP_1_2::Info.new do |info|
          info.event = 'Event'
          info.urgency = RCAP::CAP_1_2::Info::URGENCY_EXPECTED
          info.severity = RCAP::CAP_1_2::Info::SEVERITY_SEVERE
          info.certainty = RCAP::CAP_1_2::Info::CERTAINTY_LIKELY
        end
      end

      shared_examples_for('the 1.2 Info object is initialised correctly') do
        it('sets the event') { info.event.should == original_info.event }
        it('sets the urgency') { info.urgency.should == original_info.urgency }
        it('sets the severity') { info.severity.should == original_info.severity }
        it('sets the certainty') { info.certainty.should == original_info.certainty }
      end

      context('from a Hash') do
        let(:info) do
          RCAP::Info.from_h(alert, original_info.to_h)
        end

        it_should_behave_like('the 1.2 Info object is initialised correctly')
      end
    end
  end
end
