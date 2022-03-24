# frozen_string_literal: true

require 'mechanize'

module PortalInmobiliario
  class Crawler
    attr_reader :agent, :url_list

    def initialize
      @agent = Mechanize.new
      @url_list = []
    end

    def crawl(url:, link_text:, sleep_seconds: 3)
      loop do
        fetch = agent.get(url)
        link = fetch.link_with(text: link_text)

        break if link.blank?

        url = link.click.uri
        add_url_to_list(url)

        sleep sleep_seconds
      end
    end

    def add_url_to_list(url)
      @url_list += [url]
    end
  end
end
