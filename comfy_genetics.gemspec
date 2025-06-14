require_relative 'lib/comfy_genetics/version'

Gem::Specification.new do |spec|
  spec.name          = 'comfy_genetics'
  spec.version       = ComfyGenetics::VERSION
  spec.authors       = ['Your Name'] # TODO: Update with actual author
  spec.email         = ['your.email@example.com'] # TODO: Update with actual email
  spec.summary       = 'A Rails engine for genetic algorithms.'
  spec.description   = 'This engine provides models and commands for running genetic algorithm simulations.'
  spec.homepage      = 'https://example.com' # TODO: Update with actual homepage
  spec.license       = 'MIT'

  spec.files         = Dir['{app,config,db,lib}/**/*', 'MIT-LICENSE', 'Rakefile', 'README.md']
  spec.require_paths = ['lib']

  # Add dependencies here
  # spec.add_dependency 'rails', '~> 7.0' # Or your specific Rails version
end
