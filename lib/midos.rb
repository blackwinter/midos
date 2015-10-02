# encoding: utf-8

#--
###############################################################################
#                                                                             #
# midos -- A Ruby client for MIDOS databases                                  #
#                                                                             #
# Copyright (C) 2014-2015 Jens Wille                                          #
#                                                                             #
# Authors:                                                                    #
#     Jens Wille <jens.wille@gmail.com>                                       #
#                                                                             #
# midos is free software; you can redistribute it and/or modify it under the  #
# terms of the GNU Affero General Public License as published by the Free     #
# Software Foundation; either version 3 of the License, or (at your option)   #
# any later version.                                                          #
#                                                                             #
# midos is distributed in the hope that it will be useful, but WITHOUT ANY    #
# WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS   #
# FOR A PARTICULAR PURPOSE. See the GNU Affero General Public License for     #
# more details.                                                               #
#                                                                             #
# You should have received a copy of the GNU Affero General Public License    #
# along with midos. If not, see <http://www.gnu.org/licenses/>.               #
#                                                                             #
###############################################################################
#++

require 'nuggets/file/open_file'

module Midos

  # Record separator
  DEFAULT_RS = '&&&'

  # Field separator
  DEFAULT_FS = ':'

  # Value separator
  DEFAULT_VS = '|'

  # Line break indicator
  DEFAULT_NL = '^'

  # Line ending
  DEFAULT_LE = "\r\n"

  # Default file encoding
  DEFAULT_ENCODING = 'ISO-8859-1'

  class << self

    def filter(source, target, source_options = {}, target_options = source_options)
      writer, size = Writer.new(target_options.merge(io: target)), 0

      Reader.parse(source, source_options) { |*args|
        writer << args and size += 1 if yield(*args)
      }

      size
    end

    def filter_file(source_file, target_file, source_options = {}, target_options = source_options, &block)
      open_file(source_file, source_options) { |source|
        open_file(target_file, target_options, 'wb') { |target|
          filter(source, target, source_options, target_options, &block)
        }
      }
    end

    def convert(*args)
      filter(*args) { |*| true }
    end

    def convert_file(*args)
      filter_file(*args) { |*| true }
    end

    def uniq(*args)
      uniq_wrapper { |block| filter(*args, &block) }
    end

    def uniq_file(*args)
      uniq_wrapper { |block| filter_file(*args, &block) }
    end

    def open_file(filename, options = {}, mode = 'rb', &block)
      options[:encoding] ||= DEFAULT_ENCODING
      File.open_file(filename, options, mode, &block)
    end

    private

    def uniq_wrapper
      require 'nuggets/hash/seen'

      seen = Hash.seen
      yield lambda { |id, *| !seen[id] }
    end

  end

end

require_relative 'midos/base'
require_relative 'midos/reader'
require_relative 'midos/writer'
require_relative 'midos/version'
