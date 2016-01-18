class MarkdownEmail
  require 'erb'
  require 'redcarpet'

  def initialize(links)
    @links = links
  end

  def render_to_markdown
    # Configure ERB for suppressing newlines ending in %>.
    renderer = ERB.new(File.read('template/markdown_email.erb'), 0, '>')
    renderer.result(binding)
  end

  def render_to_html
    renderer = Redcarpet::Render::HTML.new({:escape_html => true})
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(render_to_markdown)
  end
end
