# frozen_string_literal: true

require_relative "lib/match_ids/version"

Gem::Specification.new do |spec|
  spec.name = "match_ids"
  spec.version = MatchIds::VERSION
  spec.authors = ["Perry Hertler"]
  spec.email = ["perry@hertler.org"]

  spec.summary = "RSpec matcher to verify that nested hashes contain no IDs."
  spec.description = <<HEREDOC
      Scenario: Your API is deprecating IDs in favor of UUIDs.#{" "}
      Use this matcher to validate no IDs are in your API responses.
HEREDOC
  spec.homepage = "https://github.com/perryqh/match_ids"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "TODO: Set to your gem server 'https://example.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = "https://github.com/perryqh/match_ids"
  spec.metadata["changelog_uri"] = "https://github.com/perryqh/match_ids/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (f == __FILE__) || f.match(%r{\A(?:(?:bin|test|spec|features)/|\.(?:git|travis|circleci)|appveyor)})
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.add_runtime_dependency "rspec-expectations", "~> 3.1"

  spec.add_development_dependency "bundler"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec", "~> 3.1"
  spec.add_development_dependency "rubocop"
  spec.add_development_dependency "rubocop-rspec"
end
