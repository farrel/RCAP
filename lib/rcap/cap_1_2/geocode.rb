module RCAP
  module CAP_1_2
    class Geocode < Parameter
      XML_ELEMENT_NAME = 'geocode' # :nodoc:
      XPATH = "cap:#{ XML_ELEMENT_NAME }" # :nodoc:
    end
  end
end
