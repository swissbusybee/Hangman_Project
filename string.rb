class String

  def colorize(color)
    "\e[#{color}m#{self}\e[0m"
  end

  def color(color)
    case color
    when :red
      colorize(31)
    when :green
      colorize(32)
    when :yellow
      colorize(33)
    when :blue
      colorize(34)
    when :pink
      colorize(35)
    when :cyan
      colorize(36)
    when :white
      colorize(37)
    when :red_b
      colorize(41)
    when :green_b
      colorize(42)
    when :yellow_b
      colorize(43)
    when :blue_b
      colorize(44)
    when :pink_b
      colorize(45)
    when :cyan_b
      colorize(46)
    when :white_b
      colorize(47)
    # black
    else
      colorize(30)
    end
  end

end
