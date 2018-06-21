class AttachmentSerializer < ActiveModel::Serializer
  attributes :id, :created_at, :updated_at, :link

  def link
    object.file.url
  end
end
