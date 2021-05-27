require_relative '../lib/checkout.rb'

describe Checkout do
    subject(:checkout) { described_class.new }
    let(:item_one) { Product.new(code: 001, name: 'Lavender heart', price: 925) }
    let(:item_two) { Product.new(code: 002, name: 'Personalised cufflinks', price: 4500) }
    let(:item_three) { Product.new(code: 003, name: 'Kids T-shirt', price: 1995) }

    describe '#scan' do
        it 'pushes an item into a basket' do
            expect(checkout.scan(item_one)).to eq [{code: 001, price: 925}]
        end

        it 'pushes multiple items into a basket' do
            checkout.scan(item_two)
            expect(checkout.scan(item_three)).to eq [{code: 002, price: 4500}, {code: 003, price: 1995}]
        end
    end

    describe '#total' do
        it 'calculates the total sum of two items in the basket' do
            checkout.scan(item_one)
            checkout.scan(item_two)
            expect(checkout.total).to eq(54.25)
        end

        it 'calculates the total sum of three items in the basket' do
            checkout.scan(item_one)
            checkout.scan(item_two)
            checkout.scan(item_three)
            expect(checkout.total).to eq(74.20)
        end
    end
end
