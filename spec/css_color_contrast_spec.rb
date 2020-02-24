RSpec.describe CssColorContrast do
  it "has a version number" do
    expect(CssColorContrast::VERSION).not_to be nil
  end

  describe '.ratio' do
    it 'expects to calculate the contrast ratio of color pairs' do
      expected_ratio = 19.555999999999997
      [
        ['#ff0', [0, 0, 0]],
        ['rgb(255, 255, 0)', 'black'],
        ['hsl(60deg, 100%, 50%)', 'hwb(60deg 0% 100%)']
      ].each do |yellow, black|
        expect(CssColorContrast.ratio(yellow, black)).to eq(expected_ratio)
      end
    end
  end

  describe '.relative_luminance' do
    it 'expects to calculate the relative luminance fo colors' do
      [
        [[0, 0, 0], 0],
        ['#000', 0],
        ['black', 0],
        ['rgb(0, 0, 0)', 0],
        ['rgb(0 0 0)', 0],
        ['hsl(0deg, 0%, 0%)', 0],
        ['hwb(0deg 0% 100%)', 0],
        [[255, 255, 0], 0.9278],
        ['hsl(60deg 100% 50%)', 0.9278],
        ['hwb(60deg 0% 0%)', 0.9278],
        [[255, 255,255], 1]
      ].each do |color, luminance|
        expect(CssColorContrast.relative_luminance(color)).to eq(luminance)
      end
    end
  end

  describe '.adjust_lightness' do
    yellow = 'rgb(255, 255, 0)'
    lime = 'rgb(0, 255, 0)'
    aa = 4.5

    it 'expects to return a lightness adjusted new color' do
      adjusted = CssColorContrast.adjust_lightness(yellow, lime, aa)

      expect(CssColorContrast.ratio(yellow, adjusted)).to be > aa
      expect(adjusted).to match(/^#[0-9a-f]+/i)
    end
  end
end
