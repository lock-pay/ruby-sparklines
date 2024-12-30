require_relative '../lib/sparklines'
require 'test/unit'

describe Sparklines do
  describe '#sparkline' do
    it 'creates a sparkline' do
      spark = Sparklines.new
      expect(spark.sparkline([1, 2, 3, 4, 5])).to eq('▁▂▄▆█')
      expect(spark.sparkline([1, 2, 3, 4, 5, 6, 7, 8])).to eq('▁▂▃▄▅▆▇█')
    end
  end

  describe '#map_item_to_symbol' do
    before do
      @sparklines = Sparklines.new
    end

    it 'maps item to correct symbol' do
      expect(@sparklines.send(:map_item_to_symbol, 0, 1, 8)).to eq('▁')
      expect(@sparklines.send(:map_item_to_symbol, 1, 1, 8)).to eq('▁')
      expect(@sparklines.send(:map_item_to_symbol, 2, 1, 8)).to eq('▂')
      expect(@sparklines.send(:map_item_to_symbol, 3, 1, 8)).to eq('▃')
      expect(@sparklines.send(:map_item_to_symbol, 4, 1, 8)).to eq('▄')
      expect(@sparklines.send(:map_item_to_symbol, 5, 1, 8)).to eq('▅')
      expect(@sparklines.send(:map_item_to_symbol, 6, 1, 8)).to eq('▆')
      expect(@sparklines.send(:map_item_to_symbol, 7, 1, 8)).to eq('▇')
      expect(@sparklines.send(:map_item_to_symbol, 8, 1, 8)).to eq('█')
      expect(@sparklines.send(:map_item_to_symbol, 9, 0, 8)).to eq('█')
    end

    it 'returns fallback symbol for non-numeric input' do
      expect(@sparklines.send(:map_item_to_symbol, 'a', 0, 8)).to eq(' ')
    end

    it 'handles negative values correctly' do
      expect(@sparklines.send(:map_item_to_symbol, -1, -2, 6)).to eq('▁')
    end

    it 'handles values outside the range correctly' do
      expect(@sparklines.send(:map_item_to_symbol, 10, 0, 1)).to eq('█')
      expect(@sparklines.send(:map_item_to_symbol, -10, 0, 1)).to eq('▁')
    end
  end

  describe 'with specified min and max' do
    it 'creates a sparkline with specified min and max' do
      spark = Sparklines.new(0, 10)
      expect(spark.sparkline([1, 2, 3, 4, 5])).to eq('▁▂▃▃▄')
    end

    it 'handles values outside the specified range correctly' do
      spark = Sparklines.new(0, 10)
      expect(spark.sparkline([-1, 0, 5, 10, 11])).to eq('▁▁▄██')
    end

    it 'handles all values being the same with specified min and max' do
      spark = Sparklines.new(0, 10)
      expect(spark.sparkline([5, 5, 5, 5, 5])).to eq('▄▄▄▄▄')
    end

    it 'handles empty input array with specified min and max' do
      spark = Sparklines.new(0, 10)
      expect(spark.sparkline([])).to eq(nil)
    end

    it 'handles non-numeric values with specified min and max' do
      spark = Sparklines.new(0, 10)
      expect(spark.sparkline([1, 'a', 3, nil, 5])).to eq('▁ ▃ ▄')
    end
  end
end
