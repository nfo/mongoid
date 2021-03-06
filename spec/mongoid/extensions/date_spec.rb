require "spec_helper"

describe Mongoid::Extensions::Date do

  describe "__mongoize_time__" do

    context "when using active support's time zone" do

      before do
        Mongoid.use_activesupport_time_zone = true
        Time.zone = "Tokyo"
      end

      after do
        Time.zone = nil
      end

      let(:date) do
        Date.new(2010, 1, 1)
      end

      let(:expected) do
        Time.zone.local(2010, 1, 1, 0, 0, 0, 0)
      end

      let(:mongoized) do
        date.__mongoize_time__
      end

      it "returns the date as a local time" do
        mongoized.should eq(expected)
      end
    end

    context "when not using active support's time zone" do

      before do
        Mongoid.use_activesupport_time_zone = false
      end

      after do
        Mongoid.use_activesupport_time_zone = true
        Time.zone = nil
      end

      let(:date) do
        Date.new(2010, 1, 1)
      end

      let(:expected) do
        Time.local(2010, 1, 1, 0, 0, 0, 0)
      end

      let(:mongoized) do
        date.__mongoize_time__
      end

      it "returns the date as a local time" do
        mongoized.should eq(expected)
      end
    end
  end

  describe ".demongoize" do

    let(:time) do
      Time.utc(2010, 1, 1, 0, 0, 0, 0)
    end

    let(:expected) do
      Date.new(2010, 1, 1)
    end

    it "keeps the date" do
      Date.demongoize(time).should eq(expected)
    end

    it "converts to a date" do
      Date.demongoize(time).should be_a(Date)
    end
  end

  describe ".mongoize" do

    context "when provided a date" do

      let(:date) do
        Date.new(2010, 1, 1)
      end

      let(:evolved) do
        Date.mongoize(date)
      end

      let(:expected) do
        Time.utc(2010, 1, 1, 0, 0, 0)
      end

      it "returns the time" do
        evolved.should eq(expected)
      end
    end

    context "when provided a string" do

      context "when the string is a valid date" do

        let(:date) do
          Date.parse("1st Jan 2010")
        end

        let(:evolved) do
          Date.mongoize(date.to_s)
        end

        let(:expected) do
          Time.utc(2010, 1, 1, 0, 0, 0, 0)
        end

        it "returns the string as a time" do
          evolved.should eq(expected)
        end
      end

      context "when the string is empty" do

        let(:evolved) do
          Date.mongoize("")
        end

        it "returns nil" do
          evolved.should be_nil
        end
      end
    end

    context "when provided a float" do

      let(:time) do
        Time.utc(2010, 1, 1, 0, 0, 0, 0)
      end

      let(:float) do
        time.to_f
      end

      let(:evolved) do
        Date.mongoize(float)
      end

      it "returns the float as a time" do
        evolved.should eq(time)
      end
    end

    context "when provided an integer" do

      let(:time) do
        Time.utc(2010, 1, 1, 0, 0, 0, 0)
      end

      let(:integer) do
        time.to_i
      end

      let(:evolved) do
        Date.mongoize(integer)
      end

      it "returns the integer as a time" do
        evolved.should eq(time)
      end
    end

    context "when provided an array" do

      let(:time) do
        Time.utc(2010, 1, 1, 0, 0, 0, 0)
      end

      let(:array) do
        [ 2010, 1, 1, 0, 0, 0, 0 ]
      end

      let(:evolved) do
        Date.mongoize(array)
      end

      it "returns the array as a time" do
        evolved.should eq(time)
      end
    end

    context "when provided nil" do

      it "returns nil" do
        Date.mongoize(nil).should be_nil
      end
    end
  end

  describe "#mongoize" do

    let(:date) do
      Date.new(2010, 1, 1)
    end

    let(:time) do
      Time.utc(2010, 1, 1, 0, 0, 0, 0)
    end

    it "returns the date as a time at midnight" do
      date.mongoize.should eq(time)
    end
  end
end
