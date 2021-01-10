require_relative 'lib/css_color_contrast/version'

Gem::Specification.new do |spec|
  spec.name          = "css_color_contrast"
  spec.version       = CssColorContrast::VERSION
  spec.authors       = ["HASHIMOTO, Naoki"]
  spec.email         = ["hashimoto.naoki@gmail.com"]

  spec.summary       = <<-SUMMARY
    Utility to calculate the contrast ratio between 2 colors, for checking
    the level of conformance to the WCAG 2.0 criteria.
    Hexadecimal notation, RGB/HSL/HWB functions are supported as input formats.
    And a command-line interface is provided for a demonstration purpose.
  SUMMARY
  #spec.description   = %q{TODO: Write a longer description or delete this line.}
  spec.homepage      = "https://github.com/nico-hn/css_color_contrast/"
  spec.license       = "MIT"
  spec.required_ruby_version = Gem::Requirement.new(">= 2.3.0")

  spec.metadata["allowed_push_host"] = "https://rubygems.org/"

  spec.metadata["homepage_uri"] = spec.homepage
  #spec.metadata["source_code_uri"] = "TODO: Put your gem's public repo URL here."
  #spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_runtime_dependency "color_contrast_calc", "~> 0.9"

  spec.add_development_dependency 'bundler', '~> 2.1'
  spec.add_development_dependency 'rake', '~> 13.0'
  spec.add_development_dependency 'rspec', '~> 3.10'
  spec.add_development_dependency 'rubocop', '~> 1.8'
  spec.add_development_dependency 'yard', '~> 0.9'
end
