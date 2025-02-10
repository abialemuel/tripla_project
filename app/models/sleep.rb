class Sleep < ApplicationRecord
  belongs_to :user

  def duration
    # handle if not clocked out
    return 0 if clock_out.nil?

    (clock_out - clock_in).to_i # Returns duration in seconds
  end
end
