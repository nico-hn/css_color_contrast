require 'css_color_contrast/command_interpreter'

Parser = CssColorContrast::CommandInterpreter::Parser

RSpec.describe CssColorContrast do
  describe CssColorContrast::CommandInterpreter do
    describe CssColorContrast::CommandInterpreter::Parser do
      let(:info_rgb) { Parser.new('info: rgb(255 255 0)') }

      describe '#read_label' do
        it 'expects to read a label' do
          info_rgb.read_label

          expect(info_rgb.tokens).to eq(%w(info))
        end
      end
    end
  end
end
