# frozen_string_literal: true

module RCAP
  module CAP_1_1
    # Subclass of {Parameter}
    class Geocode < RCAP::Base::Geocode
      XML_ELEMENT_NAME = 'geocode'
      XPATH = "cap:#{XML_ELEMENT_NAME}"

      def xmlns
        Alert::XMLNS
      end
    end
  end
end
