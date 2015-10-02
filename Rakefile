require_relative 'lib/midos/version'

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
      dependencies: { nuggets: '~> 1.4' },

      required_ruby_version: '>= 1.9.3'
    }
  }}
rescue LoadError => err
  warn "Please install the `hen' gem. (#{err})"
end
