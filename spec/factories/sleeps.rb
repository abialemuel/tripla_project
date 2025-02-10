FactoryBot.define do
  factory :sleep do
    association :user
    clock_in { Time.current }
    clock_out { Time.current + 8.hours }
  end
end
