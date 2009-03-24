Gem::Specification.new do |s|
  s.name = "audit_mass_assignment"
  s.version = "0.1.5"
  s.date = "2008-05-28"
  s.summary = "Checks Ruby on Rails models for use of the attr_accessible white list"
  s.email = "rails@ryanlowe.ca"
  s.homepage = "http://github.com/ryanlowe/audit_mass_assignment"
  s.description = "Checks Ruby on Rails models for use of the attr_accessible white list"
  s.has_rdoc = false
  s.authors = ["Ryan Lowe"]
  s.files = ["README", "CHANGELOG", "MIT-LICENSE", "audit_mass_assignment.gemspec",
    "init.rb",
    "lib/audit_mass_assignment.rb",
    "tasks/audit_mass_assignment_tasks.rake"]
  s.test_files = []
  s.rdoc_options = ["--main", "README"]
  s.extra_rdoc_files = ["README","CHANGELOG"]
  s.add_dependency("rails", ["> 2.0.0"])
end