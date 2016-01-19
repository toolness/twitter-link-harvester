require_relative 'lib/twitter_harvester'
require_relative 'lib/shared_link'
require_relative 'lib/markdown_email'
require_relative 'env'

harvester = Env.create_harvester()

links = harvester.harvest_home_timeline(20).map {|uri| SharedLink.new uri}

email = MarkdownEmail.new links

Env.configure_pony().mail(
  :body => email.render_to_markdown,
  :html_body => email.render_to_html,
  :subject => 'Harvested Twitter Links'
)
