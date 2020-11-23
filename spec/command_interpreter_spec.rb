require 'css_color_contrast/command_interpreter'

Parser = CssColorContrast::CommandInterpreter::Parser
Function = CssColorContrast::CommandInterpreter::Function

RSpec.describe CssColorContrast do
  describe CssColorContrast::CommandInterpreter do
    describe CssColorContrast::CommandInterpreter::Parser do
      let(:info_rgb) { Parser.new('info: rgb(255 255 0)') }
      let(:command_with_extra_spaces) { Parser.new(' ratio: #ff0 #000') }
      let(:colors) { Parser.new('rgb(255 255 0) #000') }

      describe '.parse!' do
        let(:yellow_and_black_ratio) { Parser.parse!('ratio: #ff0 #000') }

        it 'expects to return a function' do
          expect(yellow_and_black_ratio).to be_a(Function::Ratio)
        end
      end

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

      describe '#parse!' do
        it 'expects to parse a line of command' do
          func = info_rgb.parse!.root_node

          expect(func).to be_a(Function)
          expect(func.params.first).to be_a(ColorContrastCalc::Color)
        end

        it 'expects to ignore extra spaces at the head of line' do
          func = command_with_extra_spaces.parse!.root_node

          expect(func).to be_a(Function)
          expect(func.name).to eq('ratio')
        end
      end
    end

    describe CssColorContrast::CommandInterpreter::Function do
      describe CssColorContrast::CommandInterpreter::Function::Ratio do
        let(:yellow_black_ratio) { Parser.new('ratio: rgb(255 255 0) #000') }

        it 'expects to return the contrast ratio between yellow and black' do
          ratio_func = yellow_black_ratio.parse!.root_node

          expect(ratio_func.evaluate).to within(0.01).of(19.55)
        end
      end

      describe CssColorContrast::CommandInterpreter::Function::AdjustLightness do
        let(:red_against_white) { Parser.new('adjust: white red') }
        let(:with_default_ratio) { Parser.new('adjust: white red 4.5') }

        it 'expects to return a darker red' do
          adjust_func = red_against_white.parse!.root_node

          expect(adjust_func.evaluate.hex).to eq('#ee0000')
        end

        it 'expects to set the default ratio to 4.5' do
          implicit = red_against_white.parse!.root_node
          explicit = with_default_ratio.parse!.root_node

          expect(explicit.evaluate.hex).to eq(implicit.evaluate.hex)
        end
      end

      describe CssColorContrast::CommandInterpreter::Function::Info do
        let(:yellow_info) { Parser.new('info: rgb(255 255 0)') }
        expected = <<~EXPECTED
        ----
        yellow
        #ffff00
        rgb(255,255,0)
        hsl(60.000,100.000%,50.000%)
        EXPECTED

        it 'expects to return the information about yellow' do
          info_func = yellow_info.parse!.root_node

          expect(info_func.evaluate).to eq(expected)
        end
      end
    end
  end
end
