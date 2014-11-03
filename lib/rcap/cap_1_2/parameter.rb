module RCAP
  module CAP_1_2
    # A Parameter object is valid if
    # * it has a name
    class Parameter < RCAP::Base::Parameter
      # @return [String]
      def xmlns
        Alert::XMLNS
      end
    end
  end
end
