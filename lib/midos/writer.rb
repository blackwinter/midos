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

require 'nuggets/hash/idmap'

module Midos

  class Writer < Base

    DEFAULT_IO = $stdout

    class << self

      def write(*args, &block)
        new(extract_options!(args), &block).write(*args)
      end

      def write_file(*args, &block)
        file_method(:write, 'w', *args, &block)
      end

      def open(*args, &block)
        file_method(nil, 'w', *args, &block)
      end

      def transform(value, vs, nl)
        rvs, rnl = replacements_for(vs, nl)

        value = !value.is_a?(Array) ?
          value.to_s.gsub(vs, rvs) :
          value.map { |v| v.gsub(vs, rvs) }.join(vs)

        value.gsub!(nl, rnl)
        value.gsub!("\n", nl)

        value
      end

    end

    def vs=(vs)
      vs.is_a?(String) ? @vs = vs : raise(TypeError,
        "wrong argument type #{vs.class} (expected String)")
    end

    def write(records, *args)
      !records.is_a?(Hash) ?
        records.each { |record| write_i(nil, record, *args) } :
        records.each { |id, record| write_i(id, record, *args) }

      self
    end

    def put(record, *args)
      record.is_a?(Hash) ?
        write_i(nil, record, *args) :
        write_i(*args.unshift(*record))

      self
    end

    alias_method :<<, :put

    private

    def write_i(id, record, io = io())
      return if record.empty?

      record[key] = id || auto_id.call if key && !record.key?(key)

      record.each { |k, v|
        k ? io << k << fs << transform(v) << le :
         Array(v).each { |w| io << w.to_s << le } if v
      }

      io << rs << le << le
    end

    def transform(value)
      self.class.transform(value, vs, nl)
    end

    class Thesaurus < self

      PROLOGUE = {
        PAR: '1011111111110000000010001000000000000010',
        DAT: '00000000',
        DES: 'DE',
        TOP: 'TP~TP',
        KLA: 'CC~CC',
        OBR: 'BT~BT',
        UTR: 'NT~NT',
        SYN: 'UF~USE',
        FRU: 'PT~PT für',
        VER: 'RT~RT',
        SP1: 'ENG~ENG für',
        SP2: 'FRA~FRA für',
        SP3: 'SPA~SPA für',
        SP4: 'ITA~ITA für',
        SP5: 'GRI~GRI für',
        SP6: 'RUS~RUS für',
        SP7: 'POL~POL für',
        SP8: 'UNG~UNG für',
        SP9: 'TSC~TSC für',
        SN1: 'SN1',
        SN2: 'SN2',
        SN3: 'SN3',
        SN4: 'SN4',
        SN5: 'SN5',
        DA1: 'DATE1',
        DA2: 'DATE2',
        DA3: 'DATE3',
        DA4: 'DATE4',
        KLD: 'MIDOS Thesaurus',
        KOM: ' / ',
        KO1: 'UF',
        KO2: 'USE',
        TLE: '  32000 Zeichen',
        PAW: '',
        ART: '00000',
        REL: ' 17  1  2  3  4  5  6  7  8  9 10 11 12 13 14 15 16 18 19 20 21 22 23 24 25'
      }

      EPILOGUE = {
        DE: '*****NICHTDESKRIPTORRELATIONEN*****'
      }

      RESOLVE_FROM = [:OBR, :UTR, :VER]

      RESOLVE_TO = :DES

      NAME = :KLD

      class << self

        def write(*args, &block)
          new(extract_options!(args), &block)
            .instruct! { |mth| mth.write(*args) }
        end

        def open(*args, &block)
          super { |mth| mth.instruct!(&block) }
        end

      end

      def initialize(options = {}, prologue = {}, epilogue = {}, &block)
        super(options, &block)

        prologue[self.class::NAME] ||= options[:name]

        @prologue = self.class::PROLOGUE.merge(prologue)
        @epilogue = self.class::EPILOGUE.merge(epilogue)
      end

      attr_reader :prologue, :epilogue

      def instruct!(*args)
        put(prologue, *args)
        yield self
        put(epilogue, *args)
      end

      private

      def merge_records(hash, records, *args)
        args = [hash, records, *resolve_from_to(*args)]

        records.each { |id, record|
          new_record = hash[id] = {}

          record.each { |key, value|
            new_record[key] = resolve(key, value, *args) }
        }
      end

      def resolve_from_to(from = nil, to = prologue[RESOLVE_TO])
        from = prologue.values_at(*RESOLVE_FROM)
          .map { |v| v.split('~').first } if from.nil? || from == true

        [from, to]
      end

      def resolve(key, value, hash, records, from = nil, to = nil)
        from && from.include?(key) ? value.map { |id| records[id][to] } : value
      end

    end

    class ThesaurusX < Thesaurus

      PROLOGUE = {
        'MTX-PARAMETER' => '',
        :BEZ            => 'MIDOS Thesaurus',
        :KOM            => ' / ',
        :TXL            => 0,
        :REL            => '',
        nil             => %w[
          TT1|Topterm|TT1||||||
          BT1|Oberbegriff|BT1||||||
          NT1|Unterbegriff|NT1||||||
          RT1|Verwandter\ Begriff|RT1||||||
          SY1|Synonym1|SY1|SY1FOR|||||
        ]
      }

      EPILOGUE = {}

      NAME = :BEZ

      private

      def merge_records(hash, *)
        idmap = hash[:__list__] = Hash.idmap

        super

        idmap.replace(nil => idmap.map { |key, id| "#{key}|DE|#{id}" })
      end

      def resolve_from_to(*)
        # nothing to do
      end

      def resolve(key, value, hash, *)
        value.map { |id| hash[:__list__][id] }
      end

    end

  end

end
