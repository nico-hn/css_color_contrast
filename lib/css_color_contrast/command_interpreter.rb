# frozen_string_literal: true

require 'strscan'
require 'stringio'
require 'css_color_contrast'

module CssColorContrast
  module CommandInterpreter
    module TokenRe
      FUNC_HEAD = /:\s*/
      LABEL = /[^\s:()]+/
      SPACE = /\s+/
      COLOR_SCHEME = /(rgba?|hsl|hwb)/i
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

      class Ratio < self
        def evaluate
          ColorContrastCalc.contrast_ratio(*@params)
        end
      end

      class AdjustLightness < self
        DEFAULT_RATIO = 4.5
        def ratio_given(ratio)
          ratio && /\A\d+(\.\d+)?/.match?(ratio)
        end

        def evaluate
          fixed, to_adjust, ratio = @params

          ratio = ratio_given(ratio) ? ratio.to_f : DEFAULT_RATIO

          CssColorContrast.adjust_lightness(fixed, to_adjust, ratio)
        end
      end

      class Info < self
        def evaluate
          colors = @params.map {|c| Color.as_color(c) }
          out = StringIO.new

          colors.each do |c|
            out.puts '----'
            out.puts [c.name, c.hex, c.to_s(10)]
            out.puts format('hsl(%3.3f,%3.3f%%,%3.3f%%)', *c.hsl)
          end
          out.string
        end
      end

      def self.create(name)
        case name
        when 'ratio'
          Ratio.new(name)
        when 'adjust'
          AdjustLightness.new(name)
        when 'info'
          Info.new(name)
        end
      end
    end

    class Parser
      def self.parse!(line)
        self.new(line).parse!.root_node
      end

      attr_reader :tokens
      attr_reader :node_tree

      def initialize(line)
        @scanner = StringScanner.new(line)
        @tokens = []
        @node_tree = []
      end

      def root_node
        @node_tree.first
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
        color = Color.as_color(@scanner.scan_until(/\)/))
      end

      def read_separator
        if @scanner.scan(TokenRe::FUNC_HEAD)
          @node_tree.push(Function.create(@tokens.pop))
        elsif @scanner.scan(TokenRe::SPACE) || @scanner.eos?
          @node_tree.last.push(@tokens.pop)
        end

        read_label
        read_separator unless @tokens.empty?
      end

      def ignore_space
        @scanner.scan(TokenRe::SPACE)
      end

      def parse!
        ignore_space
        read_label
        read_separator
        self
      end
    end
  end
end
