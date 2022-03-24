# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

module PortalInmobiliario
  class Scraper
    attr_reader :url

    def initialize(url:)
      @url = url
    end

    def advertisements
      @advertisements ||= document.xpath("//a[@class='ui-search-result__content-wrapper ui-search-link']")
    end

    def mapped_advertisements(array: advertisements)
      @mapped_advertisments ||= array.map do |node|
        {
          link: node.attribute('href')&.value,
          location: node.css(
            'div.ui-search-item__group.ui-search-item__group--location p.ui-search-item__group__element.ui-search-item__location'
          ).text
        }
      end
    end

    def scrape; end

    private

    def document
      @document ||= Nokogiri::HTML(open_url(url))
    end

    def open_url(url)
      URI.open(url)
    rescue SocketError => e
    rescue HTTPError => e
      nil
    end
  end
end
