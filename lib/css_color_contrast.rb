# frozen_string_literal: true

require 'css_color_contrast/version'
require 'color_contrast_calc'

##
# Provide methods to calculate the contrast ratio
# related values from given colors.

module CssColorContrast
  class Error < StandardError; end

  ##
  # Calculate the contrast ratio between given colors.
  #
  # The contrast ratio is defined at
  # {https://www.w3.org/TR/2008/REC-WCAG20-20081211/#contrast-ratiodef}.
  # @param color1 [String, Array<Integer>] A color given as an array of
  #   integers or a string. The string can be a predefined color name,
  #   hex color code, rgb/hsl/hwb functions. Yellow, for example,
  #   can be given as [255, 255, 0], "#ffff00", "rgb(255, 255, 255)",
  #   "hsl(60deg, 100% 50%)" or "hwb(60deg 0% 0%)".
  # @param color2 [String, Array<Integer>] Same as for +color1+.
  # @return [Float] Contrast ratio

  def self.ratio(color1, color2)
    ColorContrastCalc.contrast_ratio(color1, color2)
  end
end
