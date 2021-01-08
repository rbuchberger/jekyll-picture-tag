module PictureTag
  module OutputFormats
    # This is not an output format, it's a module for use in others. It allows
    # us to create JavaScript Library friendly markup, for things like LazyLoad
    module DataAttributes
      require 'victor'
      require 'base64'

      def base_markup
        build_noscript(super)
      end

      private

      def add_src(element, image)
        element.attributes << { 'data-src' => image.uri }

        return unless PictureTag.preset['svg_placeholder']

        element.attributes << { 'src' => placeholder(image.source_width, image.source_height) }
      end

      def placeholder(width, height)
        svg = Victor::SVG.new({
                                template: :html,
                                width: width,
                                height: height
                              }).render

        'data:image/svg+xml;base64,' + Base64.encode64(svg)
      end

      def add_srcset(element, srcset)
        element.attributes << { 'data-srcset' => srcset.to_s }
      end

      def add_sizes(element, srcset)
        return unless srcset.sizes

        attribute = PictureTag.preset['data_sizes'] ? 'data-sizes' : 'sizes'
        element.attributes << { attribute => srcset.sizes }
      end

      def build_noscript(base_content)
        return base_content unless PictureTag.preset['noscript']

        noscript = DoubleTag.new(
          'noscript',
          content: Img.new.build_base_img,

          # Markdown fix requires removal of line breaks:
          oneline: PictureTag.nomarkdown?
        ).to_s

        ShelfTag.new(
          content: [base_content, noscript],

          # Markdown fix requires removal of line breaks:
          oneline: PictureTag.nomarkdown?
        )
      end
    end
  end
end
