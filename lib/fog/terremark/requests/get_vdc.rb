unless Fog.mocking?

  module Fog
    class Terremark

      # Get details of a vdc
      #
      # ==== Parameters
      # * vdc_id<~Integer> - Id of vdc to lookup
      #
      # ==== Returns
      # * response<~Excon::Response>:
      #   * body<~Hash>:

      # FIXME

      #     * 'CatalogItems'<~Array>
      #       * 'href'<~String> - linke to item
      #       * 'name'<~String> - name of item
      #       * 'type'<~String> - type of item
      #     * 'description'<~String> - Description of catalog
      #     * 'name'<~String> - Name of catalog
      def get_vdc(vdc_id)
        request(
          :expects  => 200,
          :method   => 'GET',
          :parser   => Fog::Parsers::Terremark::GetVdc.new,
          :path     => "vdc/#{vdc_id}"
        )
      end

    end
  end

else

  module Fog
    class Terremark

      def get_vdc(vdc_id)
        raise MockNotImplemented.new("Contributions welcome!")
      end

    end
  end

end