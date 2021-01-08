require 'test_helper'

module OutputFormatTestHelper
  include TestHelper

  def base_stubs
    stub_srcsets
    stub_generated_image
    stub_picture_tag

    PictureTag.stubs(source_images: [source_stub_basic], formats: %w[original],
                     crop: nil, gravity: 'center')
  end

  def stub_generated_image
    PictureTag::GeneratedImage
      .stubs(:new)
      .returns(
        GeneratedImageStub.new(
          name: 'generated.img', uri: 'good_url', width: 999, source_width: 1500, source_height: 1000
        )
      )
  end

  def source_stub_basic
    @source_stub_basic ||=
      SourceImageStub.new(name: 'img.jpg', media_preset: nil, width: 2000)
  end

  def source_stub_media
    @source_stub_media ||=
      SourceImageStub.new(
        name: 'mobile.jpg',
        media_preset: 'mobile',
        width: 2000
      )
  end

  def stub_picture_tag
    PictureTag.stubs(fallback_format: 'fallback format',
                     fallback_width: 100,
                     preset: { 'widths' => [100, 200, 300],
                               'data_sizes' => true },
                     html_attributes: {},
                     nomarkdown?: false)
  end

  def stub_pixel_srcset
    PictureTag::Srcsets::PixelRatio
      .stubs(:new).with(source_stub_basic, 'original')
      .returns(SrcsetStub.new(nil, 'pixel srcset', nil, 'original'))
  end

  def stub_width_srcset
    PictureTag::Srcsets::Width
      .stubs(:new).with(source_stub_basic, 'original')
      .returns(SrcsetStub.new(nil, 'width srcset', nil, 'original'))
  end

  def stub_sizes_srcset
    PictureTag::Srcsets::Width
      .stubs(:new)
      .returns(SrcsetStub.new('correct sizes', 'width srcset', nil, 'original'))
  end

  def stub_srcsets
    PictureTag::Srcsets::Basic
      .stubs(:new).with(source_stub_media, 'webp')
      .returns(SrcsetStub.new(nil, 'ss mobile', 'mobile', 'webp', 'mquery'))

    PictureTag::Srcsets::Basic
      .stubs(:new).with(source_stub_basic, 'webp')
      .returns(SrcsetStub.new(nil, 'ss', nil, 'webp'))

    PictureTag::Srcsets::Basic
      .stubs(:new).with(source_stub_media, 'original')
      .returns(SrcsetStub.new(nil, 'ss mobile', 'mobile', 'original', 'mquery'))

    PictureTag::Srcsets::Basic
      .stubs(:new).with(source_stub_basic, 'original')
      .returns(SrcsetStub.new(nil, 'ss', nil, 'original'))
  end

  def four_source_setup
    PictureTag
      .stubs(source_images: [source_stub_basic, source_stub_media],
             formats: %w[webp original])
  end

  def two_format_setup
    PictureTag
      .stubs(formats: %w[webp original])
  end

  def two_image_setup
    PictureTag
      .stubs(source_images: [source_stub_basic, source_stub_media])
  end

  def pixel_ratio_setup
    PictureTag
      .stubs(:preset)
      .returns('pixel_ratios' => [1, 1.5, 2], 'base_width' => 100)
  end
end
