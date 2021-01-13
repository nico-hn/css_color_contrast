# CssColorContrast

From 2 colors, calculates [the contrast ratio defined for WCAG 2.0](https://www.w3.org/TR/WCAG20/#contrast-ratiodef).

Hexadecimal notation, RGB/HSL/HWB functions are supported as input formats.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'css_color_contrast'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install css_color_contrast

## Usage

### Calculate the contrast ratio

For example, if you want to calculate the contrast ratio between yellow and black:

```ruby
require 'css_color_contrast'

CssColorContrast.ratio('#ff0', [0, 0, 0])
# => 19.555999999999997

CssColorContrast.ratio('rgb(255, 255, 0)', 'black')
# => 19.555999999999997

CssColorContrast.ratio('hsl(60deg, 100%, 50%)', 'hwb(60deg 0% 100%)')
# => 19.555999999999997
```

The following formats are supported for the arguments of `CssColorContrast.ratio()`.

* RGB values as an Array of Integers: [255, 255, 0], [0, 0, 0], etc.
* RGB values in hexadecimal notation: #ff0, #ffff00, #FF0, etc.
* RGB values in functional notation: rgb(255, 255, 0), rgb(255 255 0), etc.
* HSL colors in functional notation: hsl(60deg, 100%, 50%), hsl(60 100% 50%), etc.
* [Experimental] HWB colors in functional notation: hwb(60deg 0% 0%), hwb(60 0% 0%), etc.
* [Extended color keywords](https://www.w3.org/TR/css-color-3/#svg-color): white, black, red, etc.

### Calculate the relative luminance

You can also calculate the relative luminance of a given color as follows:

```ruby
require 'css_color_contrast'

CssColorContrast.relative_luminance('#ff0')
# => 0.9278
```

## Command-line interface

A command-line tool, ```css_color_contrast``` is provided for a demonstration purpose.

Invoke it as follows:

```bash
$ css_color_contrast
To calculate the contrast ratio between 2 colors, enter the following command:

  > ratio: color1 color2

For the values of color1 and color2, hexadecimal notation, RGB/HSL/HWB
functions and the extended color keywords are supported.

To finish the program, enter 'exit'.
> 
```

### Commands

#### ratio:

Calculate the contrast ratio between two colors as in the next case:

```bash
> ratio: rgb(255 255 0) black
19.555999999999997
> 
```

#### adjust:

It takes 3 arguments, 2 colors and a contrast ratio to be satisfied.

In the example below, it tries to adjust the lightness of the second color so
that the contrast ratio between the 2 colors is just above the target ratio.

```bash
> adjust: white red 4.5
#ee0000
> 
```

When the 3rd argument is omitted, it defaults to 4.5.

#### info:

Print the properties of a given color:

```bash
> info: #ff0
---
name: yellow
hex: #ffff00
rgb: rgb(255,255,0)
hsl: hsl(60.00,100.00%,50.00%)
hwb: hwb(60.00,0.00%,0.00%)
> 
```

#### Assignment to a variable

You can assign a color value to a varible. Variable names begin with @.

```bash
> @deeper_red: #e00
#e00
> ratio: white @deeper_red
4.530325445433122
> info: @deeper_red
---
name: #ee0000
hex: #ee0000
rgb: rgb(238,0,0)
hsl: hsl(0.00,100.00%,46.67%)
hwb: hwb(0.00,0.00%,6.67%)
> 
```
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/nico-hn/css_color_contrast. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/nico-hn/css_color_contrast/blob/master/CODE_OF_CONDUCT.md).


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the CssColorContrast project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/nico-hn/css_color_contrast/blob/master/CODE_OF_CONDUCT.md).
