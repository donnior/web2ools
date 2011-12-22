require 'rake'
Gem::Specification.new do |s|
  s.name        = 'web2ools'
  s.version     = '0.0.1'
  s.date        = '2011-12-21'
  s.summary     = "Donny's web tools!"
  s.description = "A web tools gem"
  s.authors     = ["Donny Xie"]
  s.email       = 'donnior@gmail.com'
  s.files       = FileList["lib/*.rb"].to_a
  s.homepage    = 'http://github.com/donnior/web2ools'
  s.executables = ['qiubai', 'zhidao', 'google']
end