class Checkout 

    def initialize(promotional_rules)
        @promotional_rules = promotional_rules
        @basket = []
    end

    def scan(item)
        @basket << {code: item.code, price: item.price}
    end

    def total
        discounted_basket = apply_product_promos
        total = total_sum(discounted_basket)
        apply_order_promo(total)
    end

    private

    def total_sum(discounted_basket)
        item_prices = discounted_basket.map { |k| k[:price] }
        item_prices.sum
    end

    def apply_order_promo(total)
        matching_promo = order_total_promos.find { |promo| total >= promo[:total] }
        total = total - (total * matching_promo[:discount_percentage] / 100).floor(2) if matching_promo
        total  
    end

    def apply_product_promos
        promotions_to_apply = valid_product_promos
        new_basket = @basket.map do |product|
            product[:price] = promotions_to_apply[product[:code]] if promotions_to_apply.key?(product[:code])
            product
        end
        new_basket
    end

    def valid_product_promos
        promos = {}
        basket_quantities.each do |basket_code, basket_quantity| 
            matching_promo = product_promos.find { |promo| promo[:product_code] == basket_code }
            if matching_promo && basket_quantity >= matching_promo[:quantity]
                promos[basket_code] = matching_promo[:discount_price]
            end
        end
        promos
    end

    def basket_quantities
        @basket.map { |product| product[:code] }.group_by(&:itself).transform_values(&:count)
    end

    def order_total_promos
        @promotional_rules.filter { |promo| promo[:promo_type] == "total"}
    end

    def product_promos
        @promotional_rules.filter { |promo| promo[:promo_type] == "product"}
    end
end