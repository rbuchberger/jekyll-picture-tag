# Tools to stub the jekyll and liquid interfaces
module JekyllStub
  ContextStub = Struct.new(:environments, :registers)
  SiteStub = Struct.new(:config, :data, :source, :dest)

  def build_defaults
    @widths = [25, 50, 100]
    @pconfig = {}
    @pdata = picture_data_stub

    @jekyll_env = 'development'
    @jconfig = { 'picture' => @pconfig,
                 'keep_files' => [],
                 'url' => 'example.com' }
    @data = { 'picture' => @pdata }
    @page = { 'ext' => 'html' }
    @site_source = TestHelper::TEST_DIR
    @site_dest = '/tmp/jpt'
  end

  def build_context_stub
    environments = [{ 'jekyll' => { 'environment' => @jekyll_env } }]
    registers = {
      site: @site,
      page: @page
    }

    @context = ContextStub.new(environments, registers)
  end

  def build_site_stub
    @site = SiteStub.new(
      @jconfig, @data, @site_source, @site_dest
    )
  end

  def stub_liquid
    stub_liquid_tag
    stub_template_parsing
  end

  def stub_liquid_tag
    Liquid::Template.stubs(:register_tag)
  end

  # Stubs the following:
  # Liquid::Template.parse(params).render(context)
  # Returns whatever params are originally passed in.
  def stub_template_parsing
    template_stub = Object.new
    Liquid::Template.stubs(:parse).with do |params|
      template_stub.define_singleton_method(:render) { |_context| params }
    end.returns(template_stub)
  end

  def picture_data_stub
    {
      'markup_presets' => {
        'default' => {
          'widths' => @widths
        },

        'auto' => {
          'widths' => @widths,
          'formats' => %w[webp original]
        },

        'data_auto' => {
          'markup' => 'data_auto',
          'widths' => @widths,
          'formats' => %w[webp original]
        },

        'data_img' => {
          'markup' => 'data_img',
          'widths' => @widths
        },

        'data_picture' => {
          'markup' => 'data_picture',
          'widths' => @widths,
          'formats' => %w[webp original]
        },

        'data_img_no_size' => {
          'markup' => 'data_img',
          'widths' => @widths,
          'sizes' => {
            'mobile' => '80vw'
          },
          'size' => '50%',
          'data_sizes' => false
        },

        'data_img_yes_size' => {
          'markup' => 'data_img',
          'widths' => @widths,
          'sizes' => {
            'mobile' => '80vw'
          },
          'size' => '50%',
          'data_sizes' => true
        },

        'direct_url' => {
          'markup' => 'direct_url',
          'fallback_width' => 100
        },

        'img' => {
          'markup' => 'img',
          'widths' => @widths
        },

        'naked_srcset' => {
          'markup' => 'naked_srcset',
          'widths' => @widths
        },

        'sizes' => {
          'sizes' => {
            'mobile' => '80vw'
          },
          'size' => '50%'
        },

        'pixel_ratio' => {
          'base_width' => 10,
          'pixel_ratios' => [1, 2, 3]
        },

        'attributes' => {
          'formats' => %w[webp original],
          'widths' => @widths,
          'attributes' => {
            'parent' => 'class="parent"',
            'alt' => 'Alternate Text',
            'a' => 'class="anchor"',
            'picture' => 'data-awesomeness="11"',
            'source' => 'class="source"',
            'img' => 'class="img"'
          }
        },

        'empty_attributes' => {
          'alt' => ''
        },

        'link_source' => {
          'widths' => @widths,
          'link_source' => true
        },

        'media_widths' => {
          'widths' => @widths,
          'media_widths' => {
            'mobile' => [10, 20, 30]
          }
        },

        'data_noscript' => {
          'markup' => 'data_img',
          'widths' => @widths,
          'noscript' => true
        },

        'fallback' => {
          'widths' => @widths,
          'fallback_width' => 35,
          'fallback_format' => 'webp'
        },

        'nomarkdown' => {
          'widths' => @widths,
          'nomarkdown' => true
        },

        'too_large' => {
          'widths' => [400, 600, 800],
          'fallback_width' => 800
        },

        'formats' => {
          'widths' => [100],
          'fallback_width' => 100,
          'formats' => %w[jpg jp2 png webp gif]
        },

        'quality' => {
          'quality' => 30,
          'format_quality' => {
            'webp' => 45
          }
        }
      },

      'media_presets' => {
        'mobile' => 'max-width: 600px'
      }

    }
  end
end
