require 'test/unit'
# typed: true

SYMBOLS = '▁▂▃▄▅▆▇█'.freeze
SYMBOL_COUNT = SYMBOLS.length
FALLBACK_SYMBOL = ' '.freeze
class Sparklines
  attr_accessor :min, :max

  def initialize(min = nil, max = nil)
    @min = min if min.is_a?(Float) || min.is_a?(Integer)
    @max = max if max.is_a?(Float) || max.is_a?(Integer)
  end

  def sparkline(input_array)
    return nil unless input_array.is_a?(Array) && !input_array.empty?

    min, max, _sum = find_min_max_sum(input_array)
    delta = max - min
    return SYMBOLS[0] * input_array.size if delta.zero?

    input_array.map { |item| map_item_to_symbol(item, min, max) }.join
  end

  private

  def map_item_to_symbol(item, min_border, max_border)
    return FALLBACK_SYMBOL unless item.is_a?(Integer) || item.is_a?(Float)

    clamped_item = [[item, min_border].max, max_border].min
    delta = max_border - min_border
    position = ((SYMBOL_COUNT - 1) * (clamped_item - min_border) / delta).floor
    SYMBOLS[position]
  end

  def find_min_max_sum(input_array)
    sum = 0
    max = @max || input_array[0]
    min = @min || input_array[0]

    input_array.each do |item|
      next unless item.is_a?(Integer) || item.is_a?(Float)

      min = item if @min.nil? && min > item
      max = item if @max.nil? && max < item
      sum += item
    end
    [min, max, sum]
  end
end
