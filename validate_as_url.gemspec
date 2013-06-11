# coding: utf-8
#lib = File.expand_path('../lib', __FILE__)
#$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
	spec.name = "validate_as_url"
	spec.version = '0.0.5'
	spec.author = ["Mitrofanov Dmitry"]
	spec.email = ["mdima@it-guru.biz"]
	spec.description = %q{This Gem is Used for Validations URLs}
	spec.summary = %q{This Gem is Used for Validations URLs}
	spec.homepage = "http://myitguru.info"
	spec.license = "MIT"
	#gem.add_dependency "active_support"
	#gem.add_dependency "activerecord"
	spec.files = `git ls-files`.split($/)
	spec.executables = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
	spec.test_files = spec.files.grep(%r{^(test|spec|features)/})
	spec.require_paths = ["lib"]
	spec.add_development_dependency "bundler", "~> 1.3"
	spec.add_development_dependency "rake"
end
