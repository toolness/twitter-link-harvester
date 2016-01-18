require_relative 'lib/shared_link'
require_relative 'lib/markdown_email'

module OutputExampleEmail
  LINKS = [
    SharedLink::Fake.new(
      uri: 'http://example.org/1',
      title: 'I am an <example> link',
      description: 'With a description!'
    ),
    SharedLink::Fake.new(
      uri: 'http://toolness.com/',
      title: 'I am a link with no description'
    ),
    SharedLink::Fake.new(
      uri: 'http://google.com/'
    )
  ]

  def self.run!(silent: false)
    email = MarkdownEmail.new(LINKS)

    File.open('example_email.md', 'w') do |file|
      file.write email.render_to_markdown
      print "Wrote example_email.md.\n" unless silent
    end

    File.open('example_email.html', 'w') do |file|
      file.write email.render_to_html
      print "Wrote example_email.html.\n" unless silent
    end
  end
end

OutputExampleEmail.run! if __FILE__==$0
