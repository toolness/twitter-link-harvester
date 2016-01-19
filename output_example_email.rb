require 'optparse'

require_relative 'lib/shared_link'
require_relative 'lib/markdown_email'
require_relative 'env'

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

  def self.run!(silent: false, send_email: false)
    email = MarkdownEmail.new(LINKS)

    File.open('example_email.md', 'w') do |file|
      file.write email.render_to_markdown
      print "Wrote example_email.md.\n" unless silent
    end

    File.open('example_email.html', 'w') do |file|
      file.write email.render_to_html
      print "Wrote example_email.html.\n" unless silent
    end

    if send_email
      Env.new.configure_pony.mail(
        :body => email.render_to_markdown,
        :html_body => email.render_to_html,
        :subject => 'Example Email'
      )
      print "Sent example email.\n" unless silent
    end
  end

  def self.run_cmdline!
    options = {}

    OptionParser.new do |opts|
      opts.on('-s', '--[no-]silent', "Run silently") do |silent|
        options[:silent] = silent
      end

      opts.on('-e', '--[no-]send-email', "Send email") do |send_email|
        options[:send_email] = send_email
      end
    end.parse!

    self.run!(options)
  end
end

OutputExampleEmail.run_cmdline! if __FILE__==$0
