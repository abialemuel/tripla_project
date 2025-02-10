class BaseSerializer < ActiveModel::Serializer
  def serializable_hash(*args)
    { data: super }
  end
end
