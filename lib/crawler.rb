require 'mechanize'

class Crawler
  attr_reader :agent

  def initialize
    @agent = Mechanize.new
  end
  
  def crawl(url:, link_text:, sleep_seconds: 3)
    loop do
      fetch = agent.get(url)
      link = fetch.link_with(text: link_text)

      break unless link.present?

      url = link.click.uri

      sleep sleep_seconds
    end
  end
end