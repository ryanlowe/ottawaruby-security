Gem::Specification.new do |s|
  s.name = "easy_format"
  s.version = "0.1.1"
  s.date = "2008-06-01"
  s.summary = "Formats and escapes database text for safe use in Ruby on Rails views"
  s.email = "rails@ryanlowe.ca"
  s.homepage = "http://github.com/ryanlowe/easy_format"
  s.description = "Formats and escapes database text for safe use in Ruby on Rails views"
  s.has_rdoc = false
  s.authors = ["Ryan Lowe"]
  s.files = ["README", "CHANGELOG", "MIT-LICENSE","Rakefile", "easy_format.gemspec", "init.rb","lib/easy_format.rb",
    "test/easy_format_test.rb","test/test_helper.rb"]
  s.test_files = ["test/easy_format_test.rb","test/test_helper.rb"]
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README","CHANGELOG"]
end