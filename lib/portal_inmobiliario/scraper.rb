# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'

module PortalInmobiliario
  class Scraper
    CURRENCY_EQUIVALENTS = { '$': 'clp', UF: 'uf' }.freeze

    COST_INTEGER_CSS_PATH = 'div.ui-search-item__group.ui-search-item__group--price div.ui-search-price.ui-search-price--size-medium.ui-search-item__group__element div.ui-search-price__second-line.ui-search-price__second-line--decimal span.price-tag.ui-search-price__part.price-tag-billing span.price-tag-amount span.price-tag-fraction'

    COST_CENTS_CSS_PATH = 'div.ui-search-item__group.ui-search-item__group--price div.ui-search-price.ui-search-price--size-medium.ui-search-item__group__element div.ui-search-price__second-line.ui-search-price__second-line--decimal span.price-tag.ui-search-price__part.price-tag-billing span.price-tag-amount span.price-tag-cents'

    CURRENCY_CSS_PATH = 'div.ui-search-item__group.ui-search-item__group--price div.ui-search-price.ui-search-price--size-medium.ui-search-item__group__element div.ui-search-price__second-line.ui-search-price__second-line--decimal span.price-tag.ui-search-price__part.price-tag-billing span.price-tag-amount span.price-tag-symbol'

    LOCATION_CSS_PATH = 'div.ui-search-item__group.ui-search-item__group--location p.ui-search-item__group__element.ui-search-item__location'

    attr_reader :url

    def initialize(url:)
      @url = url
    end

    def advertisements
      @advertisements ||= document.xpath("//a[@class='ui-search-result__content-wrapper ui-search-link']")
    end

    def mapped_advertisements(array: advertisements)
      @mapped_advertisements ||= array.map do |node|
        {
          currency: map_currency(node.css(CURRENCY_CSS_PATH)&.text),
          cost: map_cost_to_numeric(
            int: node.css(COST_INTEGER_CSS_PATH)&.text,
            dec: node.css(COST_CENTS_CSS_PATH)&.text
          ),
          link: node.attribute('href')&.value,
          location: node.css(
            LOCATION_CSS_PATH
          ).text
        }
      end
    end

    def scrape; end

    private

    def document
      @document ||= Nokogiri::HTML(open_url(url))
    end

    def map_cost_to_numeric(int:, dec:)
      integer = int.delete('.').to_s
      cents = ".#{dec}" if dec.present?
      # binding.break
      "#{integer}#{cents}".to_f
    end

    def map_currency(symbol)
      CURRENCY_EQUIVALENTS[symbol.to_sym]
    end

    def open_url(url)
      URI.open(url)
    rescue SocketError => e
    rescue HTTPError => e
      nil
    end
  end
end
