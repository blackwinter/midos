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

require 'nuggets/array/extract_options'

module Midos

  class Base

    class << self

      private

      def file_method(method, mode, file, options = {}, *args, &block)
        Midos.open_file(file, options, mode) { |io|
          args.unshift(options.merge(io: io))
          method ? send(method, *args, &block) : block[new(*args)]
        }
      end

      def replacements_for(*args)
        args.map { |a| "%#{a.bytes.map { |b| b.to_s(16) }.join.upcase}" }
      end

    end

    def initialize(options = {}, &block)
      self.key = options[:key]

      self.rs = options.fetch(:rs, DEFAULT_RS)
      self.fs = options.fetch(:fs, DEFAULT_FS)
      self.vs = options.fetch(:vs, DEFAULT_VS)
      self.nl = options.fetch(:nl, DEFAULT_NL)
      self.le = options.fetch(:le, DEFAULT_LE)
      self.io = options.fetch(:io, self.class::DEFAULT_IO)

      @auto_id_block = options.fetch(:auto_id, block)

      reset
    end

    attr_accessor :key, :rs, :fs, :nl, :le, :io, :auto_id

    attr_reader :vs

    def reset
      @auto_id = @auto_id_block ? @auto_id_block.call : default_auto_id
    end

    private

    def default_auto_id(n = 0)
      lambda { n += 1 }
    end

  end

end
