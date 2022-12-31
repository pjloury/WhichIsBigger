#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-


# Right now I'm getting the date parsing to work properly for historical events

# 2 CATEGORIES/QUERY
# image / ??
# age/birthdate
# height/height
# weight/weight

# history/date
# image???
# GDP/GDP
# cities/population
# countries/population
# companies/founded

# 4 UNITS
# People, lbs, Years, dollars

# 5 TAGS
# Celebrity, Athlete, Woman
#world, tech, science, usa, world

from xml.etree import cElementTree as ElementTree
import urllib2, urllib
import argparse
import re
import csv
import time, datetime
import pandas as pd
import ast
from datetime import datetime

from dateutil.parser import parse as dateparse

__topic_re = re.compile("""(.+?)\s+\|""")
__topic_re1 = re.compile("""(.+?)\s+\(""")

__name_re = re.compile("""(.+?)\s+\|""")
__name_re1 = re.compile("""(.+?)\s+\(""")

__birthday_re = re.compile("""(\d+/\d+/\d+)""")
__height_re = re.compile("""(.*)\s+(meters)""")
__person_height_re = re.compile(r"""(\d+)\'\s+(\d+)""")
__population_re = re.compile(r"""([0-9.]+)\s+(\w+)\s+people""")
__number_re = re.compile(r"""([0-9.]+)\s+(\S+)""")
__weight_re = re.compile("""(.*)\s+(lb)""")
__image_re = re.compile("""src=\"//(\S+)\?""")
__list_re = re.compile("""\d+\s+\|\s+([^\|]*)\s+\|""")

QUERYSTRING_IMAGE = "http://api.wolframalpha.com/v2/query?input=%s&appid=%s&format=plaintext,html"
QUERYSTRING = "http://api.wolframalpha.com/v2/query?input=%s&appid=%s"
APP_ID='VWK3T2-4JGT62XJP7'


class Enum(set):
    def __getattr__(self, name):
        if name in self:
            return name
        raise AttributeError


def main():

    FILENAME = "data_semicolons.csv"

    df = pd.read_csv(FILENAME, sep=';')
    df = df.astype({'name':'string','category':'string','query':'string','units':'string','imageURL':'string'})

    for index, row in df.iterrows():

        print "reading a row"

        NAME = row['name']
        CATEGORY = row['category']
        QUERY = row['query'].lower()
        UNITS = row['units'].lower()
        TAGS = row['tags']  # all tags in quotes
        VALUE = row ['value']

        #TAGS = [t.lower() for t in TAGS.split(',')]

        try:
            if pd.isna(VALUE):
                print "New Item Found:", NAME
                query_string = "%s " + QUERY
                (val, imgurl) = single_query(query_string, NAME, CATEGORY, UNITS, TAGS, VALUE)
                ### HACK TO MAKE THIS LIST JUST A SINGLE
                df.at[index, 'imageURL'] = imgurl
                df.at[index, 'value'] = val
                df.to_csv(FILENAME, index=False, sep=';')

        except Exception as e:
            print e
            pass


    print(df)


def single_query(query_string,NAME, CATEGORY, UNITS="", TAGS=[], VALUE=0):

    QUERY = urllib.quote(query_string % NAME)

    BUILT_QUERY = QUERYSTRING % (QUERY, APP_ID)
    print "Built query", BUILT_QUERY


    xml = urllib2.urlopen(BUILT_QUERY).read()
    root = ElementTree.fromstring(xml)


    TOPIC = get_topic(root)
    topicItems = [x.strip() for x in TOPIC.split(',')]
    if len(topicItems)>2:
        TOPIC = topicItems[0] + ", " + topicItems[-1]
    elif len(topicItems) == 2:
        TOPIC = topicItems[1]
    else :
        TOPIC = NAME

    PHOTO = get_image(TOPIC,TAGS)

    QUANTITY = -1

    if pd.isna(VALUE):

        # if CATEGORY == "image": # assume we are just looking for the image
        #     value = root.find("./pod[@title='Image']").find('markup').text
        #     m = __image_re.search(value)
        #     if m:
        #         PHOTO = "http://" + m.group(1)

        print "CATEGORY CHECK:", CATEGORY

        if CATEGORY == "age":
            print "Let's retrieve age!"
            QUANTITY, UNIT = parse_age(QUERY, root)

        elif CATEGORY == "population":

            QUANTITY, UNIT = parse_population(QUERY, root)

        elif CATEGORY == "height":

            QUANTITY, UNIT = parse_height(QUERY, root)

        elif CATEGORY == "weight":

            QUANTITY, UNIT = parse_weight(QUERY, root)

        else:
            print "WARNING!!! Else not person age!"
            QUANTITY, UNIT = parse(root, UNITS)

    else:
        print "OMG ELSE!!"

    # else:
    #     # QUANTITY = int(mktime(time.strptime(VALUE, "%Y")))
    #     epoch = datetime(1970, 1, 1)
    #     t = datetime(int(VALUE), 1, 1)
    #     diff = t-epoch
    #     QUANTITY = diff.total_seconds()
    #     print QUANTITY
    #     UNIT = "date"


    ############## PARSE API ##############
    print "QUANTITY", QUANTITY

    if "invented" in NAME.lower():
        NAME = NAME.lower().strip("invented").title()
    

    return(QUANTITY,PHOTO)

    ############## End PARSE API ##############


def get_topic(root):
    print root
    topic = root.find("./pod[@title='Input interpretation']").find('subpod').find('plaintext').text

    m = __topic_re.match(topic)

    if m:
        return m.group(1)
    else:

        m = __topic_re1.match(topic)

        if m:
            return m.group(1)

        raise NameError('Error parsing topic')

def get_image(NAME, TAGS):

    NAME = NAME.encode('utf-8')

    image_url = image_query(NAME)

    photo = ''

    if image_url:
        photo = "http://" + image_url

    
    #elif "city" in TAGS and not photo:
        # country = [x.strip() for x in NAME.split(',')][-1]
        # countryItems = GameItem.Query.filter(name=country).limit(1)
        # for countryItem in countryItems:
        #     if (countryItem.photoURL):
        #         photo = countryItem.photoURL
        #         print "FOUND THE URL! " + photo
        #         break

    return photo

def image_query(obj):
    obj = obj.encode('utf-8')

    QUERY = urllib.quote(obj)

    BUILT_QUERY = QUERYSTRING_IMAGE % (QUERY, APP_ID)

    xml = urllib2.urlopen(BUILT_QUERY).read()

    root = ElementTree.fromstring(xml)
    node = root.find("./pod[@title='Image']")

    if not node:
        node = root.find("./pod[@title='Flag']")
        if not node:
            return None

    value = node.find('markup').text

    m = __image_re.search(value)

    if m:
        return m.group(1)
    else:
        return None

def parse_age(QUERY, root):
    print "IN PARSE AGE"
    value = root.find("./pod[@title='Date formats']").find('subpod').find('plaintext').text

    print "Parse Age value", value

    if "month/day/year" in value:

        m = __birthday_re.match(value)

        if m:
            QUANTITY = m.group(1)
            # convert scientific notation to number
            QUANTITY = int(time.mktime(time.strptime(QUANTITY, '%m/%d/%Y')))
            UNIT = "date"
            return (QUANTITY, UNIT)

        else:
            raise NameError('No match for birthday query')

    else:
        raise NameError('No results found for query: %s' % QUERY)


def parse_population(QUERY, root):
    value = root.find("./pod[@id='Result']").find('subpod').find('plaintext').text

    print "population value", value
    # TODO: Parse Cities with populations less than 1 million
    # Example: Irvine
    # New Item Found: Irvine
    # Built query http://api.wolframalpha.com/v2/query?input=Irvine%20population&appid=VWK3T2-4JGT62XJP7
    # <Element 'queryresult' at 0x7f8a18435a80>
    # CATEGORY CHECK: population
    # population value 307670 people (country rank: 65th) (2020 estimate)
    #
    # WHEREAS: Manila works
    # New Item Found: Manila
    # Built query http://api.wolframalpha.com/v2/query?input=Manila%20population&appid=VWK3T2-4JGT62XJP7
    # <Element 'queryresult' at 0x7f89f81243c0>
    # CATEGORY CHECK: population
    # population value 1.78 million people (country rank: 1st) (2015 estimate)
    # QUANTITY 1780000.0 

    if "people" in value:

        m = __population_re.match(value)

        if m:
            QUANTITY = float(m.group(1))
            modifier = m.group(2)

            if modifier == "million":
                QUANTITY = QUANTITY * float(10 ** 6)
            elif modifier == "billion":
                QUANTITY = QUANTITY * float(10 ** 9)

            # convert scientific notation to number
            UNIT = "people"
            return (QUANTITY, UNIT)

        else:
            raise NameError('No match for population query')

    else:
        raise NameError('No results found for query: %s' % QUERY)


def parse_height(QUERY, root):
    result = root.find("./pod[@id='Result']").find('subpod').find('plaintext').text
    print result

    m = __person_height_re.match(result)

    if m:
        QUANTITY = int(m.group(1)) * 12 + int(m.group(2))

        UNIT = "inches"
        return (QUANTITY, UNIT)

    else:

        subpods = root.find("./pod[@title='Unit conversions']")

        if subpods:
            for subpod in subpods:
                value = subpod.find('plaintext').text

                if " meters" in value:

                    m = __height_re.match(value)

                    if m:
                        QUANTITY = m.group(1)

                        # convert scientific notation to number
                        QUANTITY = float(QUANTITY.replace(u"×10^", "E+").replace('~', ''))

                        UNIT = m.group(2)
                        return (QUANTITY, UNIT)

                    else:
                        raise NameError('No match for height query')

        else:
            raise NameError('No results found for query: %s' % QUERY)

        raise NameError('No match for height query')


def parse_weight(QUERY, root):
    result = root.find("./pod[@id='Result']").find('subpod').find('plaintext').text

    m = __weight_re.match(result)

    if m:
        QUANTITY = m.group(1)

        # convert scientific notation to number
        QUANTITY = float(QUANTITY.replace(u"×10^", "E+").replace('~', ''))

        UNIT = m.group(2)
        return (QUANTITY, UNIT)

    else:

        subpods = root.find("./pod[@title='Unit conversions']").find('plaintext').text

        if subpods:

            for subpod in subpods:

                value = subpod.find('plaintext').text

                if " pounds" in value:

                    m = __weight_re.match(value)

                    if m:
                        QUANTITY = m.group(1)

                        # convert scientific notation to number
                        QUANTITY = float(QUANTITY.replace(u"×10^", "E+").replace('~', ''))

                        UNIT = m.group(2)
                        return (QUANTITY, UNIT)
                    else:
                        raise NameError('No match for weight query')

        else:
            raise NameError('No results found for query: %s' % QUERY)

        raise NameError('No match for weight query')


def parse(root, UNITS):
    value = root.find("./pod[@id='Result']").find('subpod').find('plaintext').text

    if value.startswith('~~ '):
        value = value.strip('~~ ')
    m = __number_re.search(value)

    #December 17, 1903
    #month day, year
    dt = datetime.strptime(value, "%B %d, %Y")
    print "year", dt.year


    print "m", m
    if m:
        QUANTITY = float(m.group(1))
        UNIT = m.group(2).lower()

        if "trillion" in UNIT:
            QUANTITY *= pow(10, 12)
        elif "billion" in UNIT:
            QUANTITY *= pow(10, 9)
        elif "million" in UNIT:
            QUANTITY *= pow(10, 6)
        elif "thousand" in UNIT:
            QUANTITY *= pow(10, 3)

        elif "date" in UNITS:

            try:
                print "FUCK YOU 2"
                dt = dateparse(str(int(QUANTITY)))    
                QUANTITY = (dt - datetime.datetime(1970, 1, 1)).total_seconds()

            except Exception as e:

                raise NameError("Exception")

        if not UNITS:
            if "$" in value:
                UNIT = "dollars"
        else:
            UNIT = UNITS

    else:
        # check if it is a date
        try:
            print value
            if len(value) == 4:
                epoch = datetime(1970, 1, 1)
                t = datetime(int(value), 1, 1)
                diff = t-epoch
                QUANTITY = diff.total_seconds()
                print QUANTITY
            else:
                print "Not 4 chars"
                print value
                dt = dateparse(value)
                print "date object year", dt.year
                QUANTITY = dt.strftime('%s')
                #print "epoch", epoch
                #QUANTITY = (dt - datetime.datetime(1970, 1, 1)).total_seconds()
                #print "Quantityt", QUANTITY
            UNIT = "date"

        except:
            raise NameError('Could not parse!')

    print QUANTITY
    return (QUANTITY, UNIT)


if __name__ == "__main__":
    main()
