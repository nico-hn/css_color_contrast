# frozen_string_literal: true

require 'strscan'
require 'color_contrast_calc'

module CssColorContrast
  module CommandInterpreter
    module TokenRe
      LABEL = /[^\s:()]+/
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
        @tokens.push label
      end
    end
  end
end
