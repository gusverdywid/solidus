require 'spec_helper'

describe Spree::PromotionCode::CodeBuilder do
  let(:promotion) { build_stubbed :promotion }
  let(:base_code) { "abc" }
  let(:builder) do
    described_class.new promotion, base_code, num_codes
  end

  describe "#build_promotion_codes" do
    subject { builder.build_promotion_codes }

    context "with one code" do
      let(:num_codes) { 1 }

      it "builds a single promotion code" do
        subject
        expect(builder.promotion.codes).to have(num_codes).items
      end

      it "creates the promotion code with the correct value" do
        subject
        expect(builder.promotion.codes.first.value).to eq base_code
      end
    end

    context "with more than one code" do
      before { srand 123 }
      let(:num_codes) { 2 }

      it "builds the correct number of codes" do
        subject
        expect(builder.promotion.codes).to have(num_codes).items
      end

      it "builds codes with distinct values" do
        subject
        expect(builder.promotion.codes.map(&:value).uniq).to have(num_codes).items
      end

      it "builds codes with the same base prefix" do
        subject
        values = builder.promotion.codes.map &:value
        expect(values.all? { |val| val.starts_with?("#{base_code}_") }).to be true
      end

      context 'when there is a code colision' do
        before do
          @old_length = described_class.random_code_length
          described_class.random_code_length = 1
        end
        after { described_class.random_code_length = @old_length }

        let(:num_codes) { 26 }

        # With a random code length of 1, collisions happen frequently.
        # with srand(123) it happens after the second iteration.
        it "resolves the collision" do
          subject
          expect(builder.promotion.codes.map(&:value).uniq).to have(num_codes).items
        end
      end

    end
  end

end
