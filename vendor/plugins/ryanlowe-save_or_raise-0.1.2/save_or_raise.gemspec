Gem::Specification.new do |s|
  s.name = "save_or_raise"
  s.version = "0.1.2"
  s.date = "2008-05-25"
  s.summary = "A replacement for ActiveRecord::Base#save! for Ruby on Rails"
  s.email = "rails@ryanlowe.ca"
  s.homepage = "http://github.com/ryanlowe/save_or_raise"
  s.description = "A replacement for ActiveRecord::Base#save! for Ruby on Rails"
  s.has_rdoc = false
  s.authors = ["Ryan Lowe"]
  s.files = ["README", "CHANGELOG", "MIT-LICENSE","Rakefile", "save_or_raise.gemspec", "init.rb","lib/save_or_raise.rb"]
  s.test_files = []
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README","CHANGELOG"]
  s.add_dependency("rails", ["> 2.0.0"])
end