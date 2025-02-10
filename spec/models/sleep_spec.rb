require 'rails_helper'

RSpec.describe Sleep, type: :model do
  let(:user) { User.create(name: "Test User") }

  describe "#duration" do
    context "when clock_out is nil" do
      it "returns 0" do
        sleep_record = Sleep.create(user: user, clock_in: Time.current, clock_out: nil)
        expect(sleep_record.duration).to eq(0)
      end
    end

    context "when clock_out is present" do
      it "returns the correct duration in seconds" do
        clock_in_time = Time.current
        clock_out_time = clock_in_time + 8.hours
        sleep_record = Sleep.create(user: user, clock_in: clock_in_time, clock_out: clock_out_time)

        expect(sleep_record.duration).to eq(8.hours.to_i)
      end
    end

    context "when clock_out is before clock_in" do
      it "returns a negative duration" do
        clock_in_time = Time.current
        clock_out_time = clock_in_time - 2.hours
        sleep_record = Sleep.create(user: user, clock_in: clock_in_time, clock_out: clock_out_time)

        expect(sleep_record.duration).to eq(-2.hours.to_i)
      end
    end
  end
end
