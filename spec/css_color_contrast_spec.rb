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

  describe '.ratio_with_opacity' do
    yellow = 'hsl(60deg 100% 50% / 1.0)'
    lime = 'hsl(120deg 100% 50% / 0.5)'

    it 'expects to calculate the contrast ratio between transparent colors' do
      [
        [yellow, lime, 1.18],
        [lime, yellow, 1.20]
      ].each do |fore, back, expected|
        ratio = CssColorContrast.ratio_with_opacity(fore, back)
        expect(ratio).to within(0.01).of(expected)
      end
    end

    it 'expects to accept black as a base color' do
      [
        [yellow, lime, 4.78],
        [lime, yellow, 1.20]
      ].each do |fore, back, expected|
        ratio = CssColorContrast.ratio_with_opacity(fore, back, 'black')
        expect(ratio).to within(0.01).of(expected)
      end
    end
  end

  describe '.relative_luminance' do
    it 'expects to calculate the relative luminance of colors' do
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
      expect(adjusted.hex).to match(/^#[0-9a-f]+/i)
    end

    it 'expects to return nil when a satisfying color is not found' do
      adjusted = CssColorContrast.adjust_lightness(lime, yellow, aa)

      expect(adjusted).to be nil
    end
  end
end
