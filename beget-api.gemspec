Gem::Specification.new do |s|
  s.name = "beget-api"
  s.summary = "Beget API wrapper"
  s.version = "0.1"
  s.authors = "anim"
  s.email = "me@telpart.ru"
  s.homepage = "https://github.com/animotto/beget-api-ruby"
  s.license = "MIT"
  s.files = Dir["lib/*.rb"]
  s.executables = ["beget"]
  s.add_dependency "thor", "~> 1.0"
end

