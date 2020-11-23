# frozen_string_literal: true

require 'strscan'
require 'color_contrast_calc'

module CssColorContrast
  module CommandInterpreter
    module TokenRe
      LABEL = /[^\s:()]+/
      COLOR_SCHEME = /(rgba?|hwb)/i
    end

    class Parser
      attr_reader :tokens

      def initialize(line)
        @scanner = StringScanner.new(line)
        @tokens = []
      end

      def read_label
        cur_pos = @scanner.pos
        label = @scanner.scan(TokenRe::LABEL)
        if TokenRe::COLOR_SCHEME.match?(label)
          @tokens.push read_color_function(cur_pos)
        else
          @tokens.push label
        end
      end

      def read_color_function(cur_pos)
        @scanner.pos = cur_pos
        color = ColorContrastCalc.color_from(@scanner.scan_until(/\)/))
      end
    end
  end
end
