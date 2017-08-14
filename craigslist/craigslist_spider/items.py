# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class CraigslistSpiderItem(scrapy.Item):
    # define the fields for your item here like:
    url = scrapy.Field()
    title = scrapy.Field()
    address = scrapy.Field()
    description = scrapy.Field()
    compensation = scrapy.Field()
    employment_type = scrapy.Field()
