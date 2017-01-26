# -*- coding: utf-8 -*-
"""
Created on Thu Jan 26 09:20:51 2017

@author: TEAM BS
"""
#team BS#
#Bart Middelburg#
#Stijn Beernink#
#Thu 26 Jan######

import pip
from twython import Twython
import pandas as pd 
import json
import datetime 
#Geocoder can be installed in terminal by: sudo pip install geocoder
import geocoder


##codes to access twitter API. 
APP_KEY = 'N4omboT3gmZb8dqhzKizormPr'
APP_SECRET = 'xfF7o8pvqvK1zx8kxRX6uFNI9YNO3lSOYzY8e8PDyQqB4eyhZi'
OAUTH_TOKEN = '824524662394814465-xeylDNzPxXAJWgOUitffDiPL2oFKvcY'
OAUTH_TOKEN_SECRET = '5GjzQUf9PtmmWHVPJUd5Ae2utcFWiVjhywnXF2n6A4OiR'

##initiating Twython object 
twitter = Twython(APP_KEY, APP_SECRET, OAUTH_TOKEN, OAUTH_TOKEN_SECRET)


search_results = twitter.search(q='ongeval',count=2000)

outcome_coord = []
text = []
    
#parsing out 
for tweet in search_results["statuses"]:
    if tweet['place'] != None:
        tweettext = tweet['text']
        full_place_name = tweet['place']['full_name']
        g = geocoder.google(full_place_name)
        outcome_coord.append(g.latlng)
        text.append(tweettext)
    

import folium
mapit = folium.Map( location=[52.2196884, 5.0936663], zoom_start=8 )
for i in range(0,len(outcome_coord)):
    folium.Marker( location=[ outcome_coord[i][0], outcome_coord[i][1] ], popup = text[i]).add_to( mapit )

mapit.save('map.html')

