require_relative '../lib/checkout.rb'

describe Checkout do
    subject(:checkout) { described_class.new(promotional_rules) }
    let(:order_total_promo) { {promo_type: "total", total: 60, discount_percentage: 10} }
    let(:product_promo) { {promo_type: "product", quantity: 2, product_code: '001', discount_price: 8.50} }
    let(:promotional_rules) { [order_total_promo, product_promo] }
    let(:item_one) { Product.new(code: '001', name: 'Lavender heart', price: 9.25) }
    let(:item_two) { Product.new(code: '002', name: 'Personalised cufflinks', price: 45.00) }
    let(:item_three) { Product.new(code: '003', name: 'Kids T-shirt', price: 19.95) }

    describe '#scan' do
        it 'pushes an item into a basket' do
            expect(checkout.scan(item_one)).to eq [{code: '001', price: 9.25}]
        end

        it 'pushes multiple items into a basket' do
            checkout.scan(item_two)
            expect(checkout.scan(item_three)).to eq [{code: '002', price: 45.00}, {code: '003', price: 19.95}]
        end
    end

    describe '#total' do
        it 'calculates the total sum of two items in the basket with no promotion' do
            checkout.scan(item_one)
            checkout.scan(item_two)
            expect(checkout.total).to eq(54.25)
        end

        it 'applies the order total promo' do
            checkout.scan(item_one)
            checkout.scan(item_two)
            checkout.scan(item_three)
            expect(checkout.total).to eq(66.78)
        end

        it 'applies the product promo' do
            checkout.scan(item_one)
            checkout.scan(item_three)
            checkout.scan(item_one)
            expect(checkout.total).to eq(36.95)
        end

        it 'applies the order total promo and the product promo' do
            checkout.scan(item_one)
            checkout.scan(item_two)
            checkout.scan(item_one)
            checkout.scan(item_three)
            expect(checkout.total).to eq(73.76)
        end
    end
end
