class Checkout 

    def initialize
        @basket = []
    end

    def scan(item)
        @basket << {code: item.code, price: item.price}
    end

    private

    def total_sum
        item_prices = @basket.map { |k| k[:price] }
        item_prices.sum/100.to_f
    end
end