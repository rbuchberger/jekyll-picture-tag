lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'jekyll_picture_tag/version'

Gem::Specification.new do |spec|
  spec.name          = 'jekyll_picture_tag'
  spec.version       = PictureTag::VERSION
  spec.authors       = ['Robert Wierzbowski', 'Brendan Tobolaski',
                        'Robert Buchberger']
  spec.email         = ['robert@buchberger.cc']

  spec.summary       = 'Easy responsive images for Jekyll.'
  spec.description   = <<-HEREDOC
    Jekyll Picture Tag is a liquid tag that adds responsive images to your
    Jekyll static site.Jekyll Picture Tag automatically creates resized source
    images, is fully configurable, and covers all use cases — including art
    direction and resolution switching — with a little YAML configuration and a
    simple template tag.
  HEREDOC
  spec.homepage      = 'https://github.com/rbuchberger/jekyll_picture_tag'
  spec.license       = 'BSD-3-Clause'
  spec.require_paths = ['lib']

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end

  spec.required_ruby_version = ['>= 2.5', '< 3']

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_development_dependency 'minitest', '~> 5.11'
  spec.add_development_dependency 'minitest-rg'
  spec.add_development_dependency 'mocha', '~> 1.9'
  spec.add_development_dependency 'nokogiri', '~> 1.10'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'rake', '~> 12.3'
  spec.add_development_dependency 'rubocop', '~> 1.7.0'
  spec.add_development_dependency 'rubocop-minitest', '~> 0.10.0'
  spec.add_development_dependency 'rubocop-performance', '~> 1.9.0'
  spec.add_development_dependency 'rubocop-rake', '~> 0.5.0'

  spec.add_development_dependency 'simplecov', '~> 0.20.0'
  spec.add_development_dependency 'solargraph'

  spec.add_dependency 'addressable', '~> 2.6'
  spec.add_dependency 'mime-types', '~> 3.0'
  spec.add_dependency 'mini_magick', '~> 4.0'
  spec.add_dependency 'objective_elements', '~> 1.1'
  spec.add_dependency 'victor', '~> 0.3.2'

  spec.add_runtime_dependency 'jekyll', '< 5'
end
