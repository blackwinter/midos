require File.expand_path(%q{../lib/midos/version}, __FILE__)

begin
  require 'hen'

  Hen.lay! {{
    gem: {
      name:         %q{midos},
      version:      Midos::VERSION,
      summary:      %q{A Ruby client for MIDOS databases.},
      description:  %q{Access PROGRIS MIDOS databases from Ruby.},
      author:       %q{Jens Wille},
      email:        %q{jens.wille@gmail.com},
      license:      %q{AGPL-3.0},
      homepage:     :blackwinter,
      dependencies: %w[ruby-nuggets],

      required_ruby_version: '>= 1.9.3'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
