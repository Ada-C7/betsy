require "test_helper"

describe Review do
  let(:review) { reviews(:goodone, :badone).sample }

  describe "relationships" do
    it "belongs to a product" do

    end
  end

  describe "validations" do
    it "is valid with an integer rating 1-5" do

    end

    it "is invalid without a rating" do

    end

    it "is invalid without an integer rating" do

    end

    it "is invalid without a rating greater than 0" do

    end

    it "is invalid without a rating less than 6" do

    end
  end


end
