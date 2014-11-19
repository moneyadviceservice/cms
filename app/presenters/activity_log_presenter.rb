class ActivityLogPresenter < Presenter
  def header
    "#{author}, #{l(created_at, format: :date_with_time)}"
  end

  def description
    return text if note?

    "Status: #{text}"
  end

  def data_attribute
    { dough_element_filter_item: 'true' } if note?
  end

  private

  def note?
    object.type == 'note'
  end
end
