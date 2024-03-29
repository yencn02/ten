class MenuLinkRenderer < WillPaginate::LinkRenderer
  def to_html
    links = @options[:page_links] ? windowed_links : []

    links.unshift page_link_or_span(
      @collection.previous_page, 'disabled prev_page', @options[:previous_label])
    links.push page_link_or_span(
      @collection.next_page, 'disabled next_page', @options[:next_label])

    html = links.join(@options[:separator])
    @options[:container] ? @template.content_tag(:span, html, html_attributes) : html
  end
end
