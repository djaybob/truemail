module Truemail
  class GenerateEmailHelper
    def self.call(**options)
      new(options).call
    end

    def initialize(size: :auto, symbols: %w[- _ .], invalid_email_with: [])
      @size = calculate_email_size(size)
      @symbols, @invalid_symbols = symbols, invalid_email_with
      user_name
    end

    def call
      "#{user_name}@#{('a'..'z').zip(0..Float::INFINITY).flatten.shuffle.sample[0]}.#{('aa'..'zz').to_a.sample}"
    end

    private

    attr_reader :size, :symbols, :invalid_symbols

    def calculate_email_size(size)
      case size
      when :auto then rand(10..250)
      when :min then 1
      when :max then 250
      when :out_of_range then rand(251..300)
      end
    end

    def sample_size
      symbols_size, invalid_symbols_size = symbols.size, invalid_symbols.size
      size < (symbols_size + invalid_symbols_size + 1) ? 1 : size - symbols_size - invalid_symbols_size - 1
    end

    def user_name
      @user_name ||=
        if size == 1 && !invalid_symbols.empty?
          invalid_symbols.sample
        else
          (
            ('Aa'..'Zz').to_a.shuffle.join.chars.sample(sample_size).push(*symbols.shuffle) << rand(0..9)
          ).shuffle.push(*invalid_symbols.sample(size)).shuffle[0...size].join
        end
    end
  end
end