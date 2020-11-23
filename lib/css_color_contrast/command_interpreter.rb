# frozen_string_literal: true

require 'strscan'
require 'color_contrast_calc'

module CssColorContrast
  module CommandInterpreter
    module TokenRe
      FUNC_HEAD = /:\s*/
      LABEL = /[^\s:()]+/
      SPACE = /\s+/
      COLOR_SCHEME = /(rgba?|hwb)/i
    end

    class Function
      attr_reader :name
      attr_reader :params

      def initialize(name)
        @name = name
        @params = []
      end

      def push(param)
        @params.push(param)
      end
    end

    class Parser
      attr_reader :tokens
      attr_reader :node_tree

      def initialize(line)
        @scanner = StringScanner.new(line)
        @tokens = []
        @node_tree = []
      end

      def read_label
        cur_pos = @scanner.pos
        label = @scanner.scan(TokenRe::LABEL)
        return unless label
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

      def read_separator
        if @scanner.scan(TokenRe::FUNC_HEAD)
          @node_tree.push(Function.new(@tokens.pop))
        elsif @scanner.scan(TokenRe::SPACE) || @scanner.eos?
          @node_tree.last.push(@tokens.pop)
        end

        read_label
        read_separator unless @tokens.empty?
      end

      def parse
        read_label
        read_separator
      end
    end
  end
end
