module Socky
  module Server
    class CachedJsonHash < Hash

      def to_json
        @json ||= super
      end

      def remove_cache
        @json = nil
      end

    end
  end
end

