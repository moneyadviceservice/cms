module TagsHelper

  private


  # For every letter of the alphabet returns a link to tags startig by that letter.
  def index_of_existing_tags
    (:a..:z).map {|letter| link_to_tags_starting_by(prefix: letter)}.join
  end

  # Renders the link to gather the list of tags that start with the give prefix:
  def link_to_tags_starting_by(prefix:)
    link_to(prefix, starting_by_tags_path(prefix: prefix), remote: :true, data: {no_turbolink: :true, prefix: prefix}, class:'js-tags-starting-by-link')
  end

end
