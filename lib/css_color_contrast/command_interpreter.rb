# frozen_string_literal: true

require 'strscan'
require 'stringio'
require 'css_color_contrast'

module CssColorContrast
  module CommandInterpreter
    module TokenRe
      FUNC_HEAD = /:\s*/.freeze
      LABEL = /[^\s:()]+/.freeze
      SPACE = /\s+/.freeze
      COLOR_SCHEME = /(rgba?|hsl|hwb)/i.freeze
    end

    class Value
      attr_reader :source

      def self.assign(source, env, value = nil)
        new(source, env, value)
      end

      def initialize(source, env, value = nil)
        @source = source
        @env = env
        @value = value
      end

      def evaluate
        return @env[@source] if @source.start_with?('@')

        @value || @source
      end
    end

    class Function
      attr_reader :name, :params

      def initialize(name, env = {})
        @name = name
        @env = env
        @params = []
      end

      def push(param)
        @params.push(param)
      end

      def param_values
        @params.map(&:evaluate).flatten
      end

      class AssignVariable < self
        def evaluate
          @env[@name] = param_values
        end
      end

      class Ratio < self
        def evaluate
          ColorContrastCalc.contrast_ratio(*param_values)
        end
      end

      class AdjustLightness < self
        DEFAULT_RATIO = 4.5
        def ratio_given(ratio)
          ratio && /\A\d+(\.\d+)?/.match?(ratio)
        end

        def evaluate
          fixed, to_adjust, ratio = param_values

          ratio = ratio_given(ratio) ? ratio.to_f : DEFAULT_RATIO

          CssColorContrast.adjust_lightness(fixed, to_adjust, ratio)
        end
      end

      class Info < self
        def evaluate
          colors = param_values.map {|c| Color.as_color(c) }
          out = StringIO.new

          colors.each do |c|
            out.puts '---'
            out.puts [:name, :hex, :rgb].zip([c.name, c.hex, c.to_s(10)])
                       .map {|v| v.join(': ') }
            out.puts format('hsl: hsl(%3.2f,%3.2f%%,%3.2f%%)', *c.hsl)
            out.puts format('hwb: hwb(%3.2f,%3.2f%%,%3.2f%%)', *c.hwb)
          end
          out.string
        end
      end

      FUNCTION_TABLE = {
        'ratio' => Ratio,
        'adjust' => AdjustLightness,
        'info' => Info
      }.freeze

      private_constant :FUNCTION_TABLE

      def self.create(name, env = {})
        return AssignVariable.new(name, env) if name.start_with?('@')

        FUNCTION_TABLE[name].new(name, env)
      end
    end

    class Parser
      def self.parse!(line, env = {})
        new(line, env).parse!.root_node
      end

      attr_reader :tokens, :node_tree

      def initialize(line, env = {})
        @scanner = StringScanner.new(line)
        @env = env
        @tokens = []
        @node_tree = []
      end

      def root_node
        @node_tree.first
      end

      def current_node
        @node_tree.last
      end

      private :current_node

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
        source = @scanner.string[cur_pos..(@scanner.pos)]
        Value.assign(source, @env, color)
      end

      def read_separator
        if @scanner.scan(TokenRe::FUNC_HEAD)
          @node_tree.push(Function.create(@tokens.pop, @env))
        elsif @scanner.scan(TokenRe::SPACE) || @scanner.eos?
          token = @tokens.pop
          value = token.is_a?(Value) ? token : Value.assign(token, @env)
          current_node.push(value)
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
