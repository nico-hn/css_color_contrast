require 'css_color_contrast/command_interpreter'

Parser = CssColorContrast::CommandInterpreter::Parser
Function = CssColorContrast::CommandInterpreter::Function

RSpec.describe CssColorContrast do
  describe CssColorContrast::CommandInterpreter do
    describe CssColorContrast::CommandInterpreter::Parser do
      let(:info_rgb) { Parser.new('info: rgb(255 255 0)') }
      let(:colors) { Parser.new('rgb(255 255 0) #000') }

      describe '#read_label' do
        it 'expects to read a label' do
          info_rgb.read_label

          expect(info_rgb.tokens).to eq(%w(info))
        end

        it 'expects to read a color' do
          colors.read_label

          expect(colors.tokens.first).to be_a(ColorContrastCalc::Color)
        end
      end

      describe '#parse' do
        it 'expects to parse a line of command' do
          info_rgb.parse
          func = info_rgb.node_tree.first

          expect(func).to be_a(Function)
          expect(func.params.first).to be_a(ColorContrastCalc::Color)
        end
      end
    end
  end
end
