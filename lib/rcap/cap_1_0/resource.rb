module RCAP
  module CAP_1_0


    # A Resource object is valid if
    # * it has a resource description
    class Resource < RCAP::Base::Resource

      # @return [String]
      def xmlns
        Alert::XMLNS
      end
    end
  end
end
