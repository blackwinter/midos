# -*- encoding: utf-8 -*-
# stub: midos 0.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "midos"
  s.version = "0.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Jens Wille"]
  s.date = "2015-10-02"
  s.description = "Access PROGRIS MIDOS databases from Ruby."
  s.email = "jens.wille@gmail.com"
  s.extra_rdoc_files = ["README", "COPYING", "ChangeLog"]
  s.files = ["COPYING", "ChangeLog", "README", "Rakefile", "lib/midos.rb", "lib/midos/base.rb", "lib/midos/reader.rb", "lib/midos/version.rb", "lib/midos/writer.rb"]
  s.homepage = "http://github.com/blackwinter/midos"
  s.licenses = ["AGPL-3.0"]
  s.post_install_message = "\nmidos-0.2.0 [2015-10-02]:\n\n* Added +sort+ option to Midos::Writer.\n* Added Midos::Writer#[]= convenience method.\n* Fixed Midos::Writer.transform to recognize any combination of CR/LF.\n\n"
  s.rdoc_options = ["--title", "midos Application documentation (v0.2.0)", "--charset", "UTF-8", "--line-numbers", "--all", "--main", "README"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.rubygems_version = "2.4.8"
  s.summary = "A Ruby client for MIDOS databases."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nuggets>, ["~> 1.4"])
      s.add_development_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
      s.add_development_dependency(%q<rake>, [">= 0"])
    else
      s.add_dependency(%q<nuggets>, ["~> 1.4"])
      s.add_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
      s.add_dependency(%q<rake>, [">= 0"])
    end
  else
    s.add_dependency(%q<nuggets>, ["~> 1.4"])
    s.add_dependency(%q<hen>, [">= 0.8.3", "~> 0.8"])
    s.add_dependency(%q<rake>, [">= 0"])
  end
end
