# frozen_string_literal: true

require 'readline'
require 'css_color_contrast/command_interpreter'

module CssColorContrast
  module Cli
    BANNER = <<~BANNER
    To calculate the contrast ratio between 2 colors, enter the following command:

      > ratio: color1 color2

    For the values of color1 and color2, hexadecimal notation, RGB/HSL/HWB
    functions and the extended color keywords are supported.

    To finish the program, enter 'exit'.
    BANNER

    def self.print_banner
      $stdout.print BANNER
    end

    def self.read_commands
      while line = Readline.readline('> ', true)
        begin
          exit if line.chomp == 'exit'
          func = CommandInterpreter::Parser.parse!(line.chomp)
          $stdout.puts func.evaluate
        rescue => e
          puts e
        end
      end
    end

    def self.start
      print_banner
      read_commands
    end
  end
end
