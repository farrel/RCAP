module RCAP
  module CAP_1_0
    class Geocode < Parameter
      XML_ELEMENT_NAME = 'geocode' # :nodoc:
      XPATH = "cap:#{ XML_ELEMENT_NAME }" # :nodoc:
    end
  end
end
