require 'test_helper'

class TestCache < Minitest::Test
  include PictureTag
  include TestHelper

  def setup
    PictureTag.stubs(:site).returns(build_site_stub)

    @tested = Cache::Source.new('img.jpg')
  end

  # Initialize empty
  def test_initialize_empty
    assert_nil @tested[:width]
  end

  # Store data
  def test_data_store
    @tested[:width] = 100

    assert @tested[:width] = 100
  end

  # Reject bad key
  def test_reject_bad_key
    assert_raises ArgumentError do
      @tested[:asdf] = 100
    end
  end

  # Write data
  def test_write_data
    @tested[:width] = 100
    @tested.write

    assert File.exist? '/tmp/jpt/cache/img.jpg.json'
  end

  # Retrieve data
  def test_retrieve_data
    @tested[:width] = 100
    @tested.write

    assert_equal Cache::Source.new('img.jpg')[:width], 100
  end
end