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

module Midos

  class Reader < Base

    DEFAULT_IO = $stdin

    class << self

      def parse(*args, &block)
        reader = new(extract_options!(args)).parse(*args, &block)
        block ? reader : reader.records
      end

      def parse_file(*args, &block)
        file_method(:parse, 'r', *args, &block)
      end

      def transform(value, nl, vs, ovs = nil)
        rnl, rvs = replacements_for(*[nl, ovs].compact)

        value.gsub!(nl, "\n")
        value.gsub!(rnl, nl)

        !value.index(vs) ?
          replace!(value, rvs, ovs) || value :
          value.split(vs).each { |v| replace!(v, rvs, ovs) }
      end

      private

      def replace!(value, rvs, ovs)
        value.gsub!(rvs, ovs) if rvs
      end

    end

    attr_reader :records

    def reset
      super
      @records = {}
    end

    def vs=(vs)
      @vs = vs.is_a?(Regexp) ? (@ovs = nil; vs) :
        %r{\s*#{Regexp.escape(@ovs = vs)}\s*}
    end

    def parse(io = io(), &block)
      unless block
        records, block = @records, amend_block { |id, record|
          records[id] = record
        }
      end

      id, record = nil, {}

      io.each { |line|
        line = line.chomp(le)

        if line == rs
          block[key ? id : auto_id.call, record]
          id, record = nil, {}
        else
          k, v = line.split(fs, 2)
          record[k] = k == key ? id = v : transform(v) if k && v
        end
      }

      self
    end

    private

    def transform(value)
      self.class.transform(value, nl, vs, @ovs)
    end

    def amend_block(&block)
      return block unless $VERBOSE && k = @key

      r, i = block.binding.eval('_ = records, io')

      l = i.respond_to?(:lineno)
      s = i.respond_to?(:path) ? i.path :
        Object.instance_method(:inspect).bind(i).call

      lambda { |id, *args|
        if (r ||= block.binding.eval('records')).key?(id)
          warn "Duplicate record in #{s}#{":#{i.lineno}" if l}: »#{k}:#{id}«"
        end

        block[id, *args]
      }
    end

  end

end
