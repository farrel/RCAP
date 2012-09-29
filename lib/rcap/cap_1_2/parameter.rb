module RCAP
  module CAP_1_2

    # A Parameter object is valid if
    # * it has a name
    # * it has a value
    class Parameter < RCAP::Base::Parameter
      def xmlns
        Alert::XMLNS
      end
    end
  end
end
