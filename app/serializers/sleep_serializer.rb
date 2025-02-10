class SleepSerializer < ActiveModel::Serializer
  attributes :id, :clock_in, :clock_out, :duration
  belongs_to :user, serializer: UserSerializer

  def duration
    object.duration
  end
end
