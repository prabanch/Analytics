# -*- coding: utf-8 -*-
"""
Created on Sat Nov 26 16:03:33 2016

@author: prabanch
"""

from lxml import html
import requests
page = requests.get('http://econpy.pythonanywhere.com/ex/001.html')
tree = html.fromstring(page.content)

print('Test')


#This will create a list of buyers:
buyers = tree.xpath('//div[@title="buyer-name"]/text()')
#This will create a list of prices
prices = tree.xpath('//span[@class="item-price"]/text()')

#Let’s see what we got exactly:

print( 'Buyers: '), buyers
print( 'Prices: '), prices

