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
end
