# frozen_string_literal: true

require_relative "lib/sxg_checker/version"

Gem::Specification.new do |spec|
  spec.name = "sxg_checker"
  spec.version = SxgChecker::VERSION
  spec.authors = ["Paweł Pokrywka"]
  spec.email = ["pepawel@users.noreply.github.com"]

  spec.summary = "Checks SXG document and its subresources validity."
  spec.homepage = "https://github.com/pepawel/sxg_checker"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.0.0"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/pepawel/sxg_checker/blob/main/CHANGELOG.md"

  gemspec = File.basename(__FILE__)
  spec.files = IO.popen(%w[git ls-files -z], chdir: __dir__, err: IO::NULL) do |ls|
    ls.readlines("\x0", chomp: true).reject do |f|
      (f == gemspec) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "http", "~> 5.2"
  spec.add_dependency "parallel", "~> 1.27"
end
