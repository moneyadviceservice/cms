module TagsHelper
  private

  # For every letter of the alphabet returns a link to tags starting with that letter.
  def index_of_existing_tags
    (:a..:z).map { |letter| link_to_tags_starting_by(prefix: letter) }.join
  end

  # Renders the link to gather the list of tags that start with the given prefix:
  def link_to_tags_starting_by(prefix:)
    link_to(prefix, starting_by_tags_path(prefix: prefix),
            remote: true,
            data:   { no_turbolink: true, prefix: prefix },
            class:  'pagination__item js-tags-starting-by-link')
  end

  # The header to display in the list of existing tags.
  def header_for_list_of_tags(tags, prefix)
    i18n_key  = tags.any? ? '.header' : '.no_tags'
    css_class = tags.any? ? 'js-existing-tags-msg' : 'js-tags-no-tags-msg'
    content_tag(:span, t(i18n_key, prefix: prefix.upcase), class: css_class)
  end
end
