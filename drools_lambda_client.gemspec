
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "drools_lambda_client/version"

Gem::Specification.new do |spec|
  spec.name          = "drools_lambda_client"
  spec.version       = DroolsLambdaClient::VERSION
  spec.authors       = ["Priyanka"]
  spec.email         = ["priyankatrancedi.iitd@gmail.com"]

  spec.summary       = "Expose a method to call drools deployed in lambda"
  spec.description   = "Expose a method to call drools deployed in lambda"
  spec.homepage      = "https://github.com/Priyanka-Soni-id/drools_lambda_client"
  spec.license       = "MIT"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files         = Dir.chdir(File.expand_path('..', __FILE__)) do
    `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  end
  
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.16"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "byebug"
  spec.add_dependency "activesupport"
  spec.add_dependency "aws-sdk"

end
