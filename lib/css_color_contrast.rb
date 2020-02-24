# frozen_string_literal: true

require 'css_color_contrast/version'
require 'color_contrast_calc'
require 'css_color_contrast/color'

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

  ##
  # Calculate the relative luminance of a color.
  #
  # The definition of relative luminance is given at
  # {https://www.w3.org/TR/2008/REC-WCAG20-20081211/#relativeluminancedef}.
  # @param color [String, Array<Integer>] A color given as an array of
  #   integers or a string. The string can be a name of predefined
  #   color, hex color code, rgb/hsl/hwb functions. Yellow, for example,
  #   can be given as [255, 255, 0], "#ffff00", "rgb(255, 255, 255)",
  #   "hsl(60deg, 100% 50%)" or "hwb(60deg 0% 0%)".
  # @return [Float] Relative luminance of the passed color.

  def self.relative_luminance(color)
    Color.as_color(color).relative_luminance
  end

  ##
  # Adjust the lightness of the second color to satisfy a specified
  # level of contrast ratio.
  #
  # @param fixed_color [String, Array<Integer, Float>] The color that
  #   remains unchanged
  # @param color_to_adjust [String, Array<Integer, Float>] The color of
  #   which the lightness is to be adjusted
  # @param level [Integer, Float] The level of contrast ratio to be
  #   satisfied, such as 3.0, 4.5, 7.0
  # @return [String] RGB value in hexadecimal notation

  def self.adjust_lightness(fixed_color, color_to_adjust, level = 4.5)
    fixed, to_adjust = [fixed_color, color_to_adjust].map do |color|
      Color.as_color(color)
    end

    fixed.find_lightness_threshold(to_adjust, level).hex
  end
end
