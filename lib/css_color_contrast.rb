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
  # Calculate the contrast ratio between two transparent colors.
  #
  # For the calculation of contrast ratio between foreground and
  # background colors, you need another color which is placed below
  # the former two colors, because the third color filters through
  # the overlaid colors.
  #
  # @param foreground [String, Array<Integer>, Color] The uppermost
  #   color such as "rgb(255, 255, 0, 0.5)" or "hsl(60 100% 50% / 50%)"
  # @param background [String, Array<Integer>, Color] The color placed
  #   between the others
  # @param base [String, Array<Integer>, Color] The color placed in
  #   the bottom. When the backgound is completely opaque, this color
  #   is ignored.
  # @return [Float] Contrast ratio

  def self.ratio_with_opacity(foreground, background, base = Color::WHITE)
    ColorContrastCalc.contrast_ratio_with_opacity(foreground, background, base)
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
  # @param level [Integer, Float] The contrast ratio to be satisfied,
  #   such as 3.0, 4.5, 7.0
  # @return [Color, nil] The color of which the contrast ratio against
  #   fixed_color equals or is slightly greater than the specified level.

  def self.adjust_lightness(fixed_color, color_to_adjust, level = 4.5)
    fixed, to_adjust = [fixed_color, color_to_adjust].map do |color|
      Color.as_color(color)
    end

    adjusted = fixed.find_lightness_threshold(to_adjust, level)
    if_satisfied = fixed.contrast_ratio_against(adjusted) >= level

    if_satisfied ? adjusted : nil
  end
end
