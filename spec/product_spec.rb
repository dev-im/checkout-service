require 'product'

describe Product do
    subject(:product) { described_class.new(code: '002', name: 'Personalised cufflinks', price: 45.00)}

    describe '#code' do
        it 'is expected to return the code of the item' do
            expect(product.code).to eq '002'
        end
    end

    describe '#price' do
        it 'is expected to return the name of the item' do
            expect(product.price).to eq 45.00 
        end
    end     
end