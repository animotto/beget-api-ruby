# frozen_string_literal: true

Gem::Specification.new do |s|
  s.name = 'beget_api'
  s.summary = 'Beget API wrapper'
  s.version = '0.1'
  s.authors = 'anim'
  s.email = 'me@telpart.ru'
  s.homepage = 'https://github.com/animotto/beget-api-ruby'
  s.license = 'MIT'
  s.files = Dir['lib/*.rb']
  s.executables = ['beget']
  s.required_ruby_version = '>= 2.4'
  s.add_development_dependency 'rubocop', '~> 1.12'
end
