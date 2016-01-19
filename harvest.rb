require 'optparse'

require_relative 'lib/twitter_harvester'
require_relative 'lib/shared_link'
require_relative 'lib/markdown_email'
require_relative 'env'

module Harvest
  def self.run!(count: 20, silent: false)
    env = Env.new
    harvester = env.create_harvester

    print "Fetching #{count} timeline entries...\n" unless silent

    links = harvester.harvest_home_timeline(count)
    links = links.each_with_index.map do |uri, i|
      print "Fetching link #{i} of #{links.length} " unless silent
      print "@ #{uri.host}...\n" unless silent
      SharedLink.new uri
    end

    print "Sending email...\n" unless silent

    email = MarkdownEmail.new links

    env.configure_pony.mail(
      :body => email.render_to_markdown,
      :html_body => email.render_to_html,
      :subject => 'Harvested Twitter Links'
    )
  end

  def self.run_cmdline!
    options = {}

    OptionParser.new do |opts|
      opts.on('-s', '--[no-]silent', "Run silently") do |silent|
        options[:silent] = silent
      end

      opts.on('--count N', Integer, "Harvest latest N tweets") do |n|
        options[:count] = n
      end
    end.parse!

    self.run!(options)
  end
end

Harvest.run_cmdline! if __FILE__==$0
