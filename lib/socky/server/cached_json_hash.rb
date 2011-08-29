module Socky
  module Server
    class CachedJsonHash < Hash
      include Misc

      def to_json
        @json ||= super
      end

    end
  end
end

