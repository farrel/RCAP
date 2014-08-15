module RCAP
  module Info
    def self.from_h(alert, info_hash)
      case alert.class::CAP_VERSION
      when CAP_1_0::Alert::CAP_VERSION
        CAP_1_0::Info.from_h(info_hash)
      when CAP_1_1::Alert::CAP_VERSION
        CAP_1_1::Info.from_h(info_hash)
      else
        CAP_1_2::Info.from_h(info_hash)
      end
    end
  end
end
