# -*- coding: utf-8 -*-

import scrapy
from quotes_spider.items import QuotesSpiderItem

##
## Spider to crawl quotes.toscrape.com site
## The code is mostly based on the following scrapy tutorial doc
## https://docs.scrapy.org/en/latest/intro/overview.html
##
class QuotesSpider(scrapy.Spider):
    name = 'quotes'
    allowed_domains = ['quotes.toscrape.com']
    start_urls = [
        'http://quotes.toscrape.com/'
    ]

    def parse(self, response):
        for quote in response.css('div.quote'):
            item = QuotesSpiderItem()
            item['text'] = quote.css('span.text::text').extract_first()
            item['author'] = quote.xpath('span/small/text()').extract_first()
            yield item

        next_page = response.css('li.next a::attr("href")').extract_first()
        if next_page is not None:
            yield response.follow(next_page, self.parse)
