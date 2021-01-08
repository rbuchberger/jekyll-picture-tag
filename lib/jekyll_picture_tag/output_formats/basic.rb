module PictureTag
  # Contains all possible HTML output format options. Auto is considered its
  # own option.
  module OutputFormats
    # Generic functions common to all output formats.
    class Basic
      include ObjectiveElements

      def to_s
        wrap(base_markup).to_s
      end

      # Used for both the fallback image, and for the complete markup.
      def build_base_img
        img = SingleTag.new 'img'
        attributes = PictureTag.html_attributes

        img.attributes << attributes['img']
        img.attributes << attributes['implicit']

        fallback = build_fallback_image

        add_src(img, fallback)

        add_alt(img, attributes['alt'])

        img
      end

      private

      # Handles various wrappers around basic markup
      def wrap(markup)
        if PictureTag.html_attributes['link']
          markup = anchor_tag(markup)
          markup = nomarkdown_wrapper(markup.to_s) if PictureTag.nomarkdown?
        end

        markup
      end

      # Media is the media query associated with the desired source image.
      def build_srcset(source_image, format)
        if PictureTag.preset['pixel_ratios']
          Srcsets::PixelRatio.new(source_image, format)
        else
          Srcsets::Width.new(source_image, format)
        end
      end

      # Extracting these functions to their own methods for easy overriding.
      def add_src(element, image)
        element.src = image.uri
      end

      def add_srcset(element, srcset)
        element.srcset = srcset.to_s
      end

      def add_sizes(element, srcset)
        element.sizes = srcset.sizes if srcset.sizes
      end

      def add_alt(element, alt)
        element.alt = alt if alt
      end

      def add_media(element, srcset)
        element.media = srcset.media_attribute if srcset.media
      end

      # GeneratedImage class, not HTML
      def build_fallback_image
        return fallback_candidate if fallback_candidate.exists?

        image = GeneratedImage.new(
          source_file: PictureTag.source_images.first,
          format: PictureTag.fallback_format,
          width: checked_fallback_width,
          crop: PictureTag.crop,
          gravity: PictureTag.gravity
        )

        image.generate

        image
      end

      # It's only a candidate, because we don't know if the fallback width
      # setting is larger than the source file.
      def fallback_candidate
        @fallback_candidate ||= GeneratedImage.new(
          source_file: PictureTag.source_images.first,
          format: PictureTag.fallback_format,
          width: PictureTag.fallback_width,
          crop: PictureTag.crop,
          gravity: PictureTag.gravity
        )
      end

      # Stops kramdown from molesting our output
      # Must be given a string.
      #
      # Kramdown is super picky about the {::nomarkdown} extension-- we have to
      # strip line breaks or nothing works.
      def nomarkdown_wrapper(content)
        "{::nomarkdown}#{content.delete("\n").gsub(/>  </, '><')}{:/nomarkdown}"
      end

      def anchor_tag(content)
        anchor = DoubleTag.new 'a'
        anchor.attributes << PictureTag.html_attributes['a']
        anchor.href = PictureTag.html_attributes['link']

        content.add_parent anchor
      end

      def source
        PictureTag.source_images.first
      end

      def source_width
        if PictureTag.crop
          fallback_candidate.source_width
        else
          source.width
        end
      end

      def checked_fallback_width
        target = PictureTag.fallback_width

        if target > source_width
          Utils.warning "#{source.shortname} is smaller than the " \
            "requested fallback width of #{target}px. Using #{source_width}" \
            ' px instead.'
          source_width
        else
          target
        end
      end
    end
  end
end
