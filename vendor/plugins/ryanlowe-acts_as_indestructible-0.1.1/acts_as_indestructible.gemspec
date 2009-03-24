Gem::Specification.new do |s|
  s.name = "acts_as_indestructible"
  s.version = "0.1.1"
  s.date = "2008-05-26"
  s.summary = "Mark objects as destroyed instead of deleting them from the database for Ruby on Rails ActiveRecord"
  s.email = "rails@ryanlowe.ca"
  s.homepage = "http://github.com/ryanlowe/acts_as_indestructible"
  s.description = "Mark objects as destroyed instead of deleting them from the database for Ruby on Rails ActiveRecord"
  s.has_rdoc = false
  s.authors = ["Ryan Lowe"]
  s.files = ["README", "CHANGELOG", "MIT-LICENSE", "Rakefile", "acts_as_indestructible.gemspec", "init.rb",
    "lib/acts_as_indestructible.rb","lib/fixture.rb"]
  s.test_files = []
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README","CHANGELOG"]
  s.add_dependency("rails", ["> 2.0.0"])
end