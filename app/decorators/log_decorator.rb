class LogDecorator < Draper::Decorator
  delegate_all

  def created_at
    model.created_at.to_time
  end

  def url
    raise NotImplementedError
  end

  def friendly_type
    type.humanize
  end
end
