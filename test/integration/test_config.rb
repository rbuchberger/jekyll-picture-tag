require_relative './test_integration_helper'
class TestIntegrationConfig < Minitest::Test
  include TestIntegrationHelper

  def setup
    base_stubs
  end

  def teardown
    cleanup_files
  end

  def test_nomarkdown_autodetect
    @page['ext'] = '.md'
    output = tested_base 'rms.jpg --link example.com'

    assert nomarkdown_wrapped? output
  end

  def test_nomarkdown_disable
    @pconfig['nomarkdown'] = false
    @page['ext'] = '.md'
    output = tested_base 'rms.jpg --link example.com'

    refute nomarkdown_wrapped? output
  end

  def test_warning
    tested 'too_large rms.jpg'

    assert @stderr.include? 'rms.jpg'
  end

  # suppress warnings
  def test_suppress_warnings
    @pconfig['suppress_warnings'] = true
    tested 'too_large rms.jpg'

    assert @stderr.empty?
  end

  # continue on missing
  def test_missing_source
    File.unstub(:exist?)
    @pconfig['ignore_missing_images'] = true

    output = tested 'asdf.jpg'

    ss = '/generated/asdf-25-xxxxxx.jpg 25w,' \
      ' /generated/asdf-50-xxxxxx.jpg 50w, /generated/asdf-100-xxxxxx.jpg 100w'

    assert_equal ss, output.at_css('img')['srcset']
    assert @stderr.include? 'asdf.jpg'
  end

  def test_missing_source_array
    File.unstub(:exist?)
    @pconfig['ignore_missing_images'] = %w[development testing]

    output = tested 'asdf.jpg'

    ss = '/generated/asdf-25-xxxxxx.jpg 25w,' \
      ' /generated/asdf-50-xxxxxx.jpg 50w, /generated/asdf-100-xxxxxx.jpg 100w'

    assert_equal ss, output.at_css('img')['srcset']
    assert @stderr.include? 'asdf.jpg'
  end

  def test_missing_source_string
    File.unstub(:exist?)
    @pconfig['ignore_missing_images'] = 'development'

    output = tested 'asdf.jpg'

    ss = '/generated/asdf-25-xxxxxx.jpg 25w,' \
      ' /generated/asdf-50-xxxxxx.jpg 50w, /generated/asdf-100-xxxxxx.jpg 100w'

    assert_equal ss, output.at_css('img')['srcset']
    assert @stderr.include? 'asdf.jpg'
  end

  def test_missing_source_nocontinue
    File.unstub(:exist?)

    assert_raises do
      tested 'asdf.jpg'
    end
  end

  def test_absolute_urls
    @pconfig['relative_url'] = false

    ss = 'example.com/generated/rms-25-46a48b.jpg 25w,' \
      ' example.com/generated/rms-50-46a48b.jpg 50w,' \
      ' example.com/generated/rms-100-46a48b.jpg 100w'

    assert_equal ss, tested.at_css('img')['srcset']
  end

  def test_baseurl
    @jconfig['baseurl'] = 'blog'

    ss = '/blog/generated/rms-25-46a48b.jpg 25w, ' \
    '/blog/generated/rms-50-46a48b.jpg 50w,' \
    ' /blog/generated/rms-100-46a48b.jpg 100w'

    assert_equal ss, tested.at_css('img')['srcset']
  end

  # cdn url
  def test_cdn
    @context.environments = [{ 'jekyll' => { 'environment' => 'production' } }]
    @pconfig['cdn_url'] = 'cdn.net'
    ss = 'cdn.net/generated/rms-25-46a48b.jpg 25w,' \
      ' cdn.net/generated/rms-50-46a48b.jpg 50w,' \
      ' cdn.net/generated/rms-100-46a48b.jpg 100w'

    assert_equal ss, tested.at_css('img')['srcset']
  end

  # cdn environments
  def test_cdn_env
    @pconfig['cdn_url'] = 'cdn.net'
    @pconfig['cdn_environments'] = ['development']
    ss = 'cdn.net/generated/rms-25-46a48b.jpg 25w,' \
      ' cdn.net/generated/rms-50-46a48b.jpg 50w,' \
      ' cdn.net/generated/rms-100-46a48b.jpg 100w'

    assert_equal ss, tested.at_css('img')['srcset']
  end

  # preset not found warning
  def test_missing_preset
    tested('asdf rms.jpg')

    assert @stderr.include? 'asdf'
  end

  # small src (fallback)
  # small source in srcset
  def test_small_source
    output = tested 'too_large rms.jpg'
    src = '/generated/rms-100-46a48b.jpg'
    ss = '/generated/rms-100-46a48b.jpg 100w'

    assert @stderr.include? 'rms.jpg'
    assert_equal src, output.at_css('img')['src']
    assert_equal ss, output.at_css('img')['srcset']
  end

  def test_disabled
    @pconfig['disabled'] = ['development']

    assert_equal tested_base, ''
  end

  def test_fast_build
    File.stubs(:exist?).returns(true)
    @pconfig['fast_build'] = true

    Digest::MD5.expects(:hexdigest).never
    Dir.expects(:glob)
       .with('/tmp/jpt/generated/rms-800-??????.jpg')
       .returns(['/tmp/jpt/generated/rms-800-46a48b.jpg'])

    output = tested 'rms.jpg'
    assert_equal std_rms_ss, output.at_css('img')['srcset']
  end

  # When building images which already exist, source image width should never be
  # called because it's a huge performance hit.
  def test_no_width_check
    File.stubs(:exist?).returns(true)
    SourceImage.any_instance.expects(:width).never

    tested
  end
end
