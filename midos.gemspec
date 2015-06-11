# -*- encoding: utf-8 -*-
# stub: midos 0.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "midos"
  s.version = "0.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jens Wille"]
  s.date = "2015-06-11"
  s.description = "Access PROGRIS MIDOS databases from Ruby."
  s.email = "jens.wille@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["COPYING", "ChangeLog", "README", "Rakefile", "lib/midos.rb", "lib/midos/base.rb", "lib/midos/reader.rb", "lib/midos/version.rb", "lib/midos/writer.rb"]
  s.homepage = "http://github.com/blackwinter/midos"
  s.licenses = ["AGPL-3.0"]
  s.post_install_message = "\nmidos-0.1.1 [2015-06-11]:\n\n* Fixed replacement of special characters in Midos::Reader.\n\n"
  s.rdoc_options = ["--title", "midos Application documentation (v0.1.1)", "--charset", "UTF-8", "--line-numbers", "--all", "--main", "README"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.8"
  s.summary = "A Ruby client for MIDOS databases."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nuggets>, [">= 0"])
      s.add_development_dependency(%q<hen>, [">= 0.8.1", "~> 0.8"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<nuggets>, [">= 0"])
      s.add_dependency(%q<hen>, [">= 0.8.1", "~> 0.8"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<nuggets>, [">= 0"])
    s.add_dependency(%q<hen>, [">= 0.8.1", "~> 0.8"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
