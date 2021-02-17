require_relative "lib/nomadic/version"

Gem::Specification.new do |spec|
  spec.name = "nomadic"
  spec.version = Nomadic::VERSION
  spec.authors = ["Erik Olson"]
  spec.email = ["xorgnak@gmail.com"]

  spec.summary = ""
  spec.homepage = "https://github.com/xorgnak/urban-chainsaw"
  spec.license = "MIT"

  spec.metadata = {
    "bug_tracker_uri" => "https://github.com/xorgnak/urban-chainsaw/issues",
    "changelog_uri" => "https://github.com/xorgnak/urban-chainsaw/releases",
    "source_code_uri" => "https://github.com/xorgnak/urban-chainsaw",
    "homepage_uri" => spec.homepage
  }

  # Specify which files should be added to the gem when it is released.
  spec.files = Dir.glob(%w[LICENSE.txt README.md {exe,lib}/**/*]).reject { |f| File.directory?(f) }
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
end
