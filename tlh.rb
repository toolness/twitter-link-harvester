require 'thor'

require_relative 'lib/twitter_harvester'
require_relative 'lib/shared_link'
require_relative 'lib/markdown_email'
require_relative 'lib/env'

class TwitterLinkHarvester < Thor
  class_option :silent, :type => :boolean, :desc => "Run silently"

  desc "harvest", "Harvest latest tweets from timeline"
  option :count, :type => :numeric, :default => 20,
         :desc => "Harvest latest COUNT tweets"
  def harvest
    env = Env.new
    harvester = env.create_harvester

    log "Fetching #{options[:count]} timeline entries..."

    links = harvester.harvest_home_timeline(options[:count])
    links = links.each_with_index.map do |uri, i|
      log "Fetching link #{i+1} of #{links.length} @ #{uri.host}..."
      SharedLink.new uri
    end

    log "Sending email..."

    email = MarkdownEmail.new links

    env.configure_pony.mail(
      :body => email.render_to_markdown,
      :html_body => email.render_to_html,
      :subject => 'Harvested Twitter Links'
    )    
  end

  desc "example_email", "Output example email w/ sample links"
  option :send, :type => :boolean, :desc => "Send email"
  def example_email
    links = [
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

    email = MarkdownEmail.new(links)

    File.open('example_email.md', 'w') do |file|
      file.write email.render_to_markdown
      log "Wrote example_email.md."
    end

    File.open('example_email.html', 'w') do |file|
      file.write email.render_to_html
      log "Wrote example_email.html."
    end

    if options[:send]
      Env.new.configure_pony.mail(
        :body => email.render_to_markdown,
        :html_body => email.render_to_html,
        :subject => 'Example Email'
      )
      log "Sent example email."
    end
  end

  no_commands do
    def log(msg)
      puts msg unless options[:silent]
    end
  end
end

TwitterLinkHarvester.start(ARGV) if __FILE__==$0
