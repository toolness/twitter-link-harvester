require 'markdown_email'
require 'shared_link'

require_relative '../output_example_email'

describe MarkdownEmail do
  it 'should pass smoke test' do
    OutputExampleEmail.run! silent: true
  end

  describe '#render_to_html' do
    it 'should not explode if passed no links' do
      MarkdownEmail.new([]).render_to_html
    end

    it 'should not explode if passed only one link' do
      MarkdownEmail.new([
        SharedLink::Fake.new(uri: 'http://example.org')
      ]).render_to_html
    end

    it 'should use UTF-8' do
      html = MarkdownEmail.new([]).render_to_html
      expect(html.encoding.name).to eql('UTF-8')
    end
  end
end
