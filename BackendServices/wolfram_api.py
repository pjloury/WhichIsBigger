#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

#python wolfram_api.py --csv = /

from xml.etree import cElementTree as ElementTree
import urllib2, urllib
import argparse
import re
import csv
import time, datetime

from parse_rest.connection import register
from parse_rest.datatypes import Object

from dateutil.parser import parse as dateparse

#from api_keys import *


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
PARSE_APP_ID='mQP5uTJvSvOmM2UNXxe31FsC5BZ1sP1rkABnynbd'
REST_API_KEY='04Tsc8rIcaimvW3mveSzTHhy20VmGx5EQVwFIdV1'
############## WOLFRAM API ##############

register(PARSE_APP_ID, REST_API_KEY)


class GameItem(Object):
    pass


class Enum(set):
    def __getattr__(self, name):
        if name in self:
            return name
        raise AttributeError

############## END WOLFRAM API ##############


def main():
    parser = argparse.ArgumentParser(description='wolfram to parse backend service')

    parser.add_argument('--csv', type=file, dest='csvfile',
                        help='csv file to parse')

    args = parser.parse_args()
    csvfile = args.csvfile

    # parse a csv file for entities to query
    if csvfile:

        print "loading csv"

        reader = csv.reader(csvfile)

        # skip first line of csv (assume this is header)
        next(reader, None)

        for row in reader:

            print "reading a row"
            if len(row) < 2:
                continue

            NAME = row[0]
            CATEGORIES = row[1]
            QUERY = row[2].lower()
            UNITS = row[3].lower()
            TAGS = row[4]  # all tags in quotes

            # check for existing parse entry
            exists = GameItem.Query.all().filter(name=NAME, category=CATEGORIES)
            if len(exists) > 0:
                print "Duplicate found"
                continue

            TAGS = [t.lower() for t in TAGS.split(',')]
            CATEGORIES = [t.lower() for t in CATEGORIES.split(',')]

            for category in CATEGORIES:

                # gracefully catch exception and move to next query
                try:
                    query_string = "%s " + QUERY
                    single_query(query_string,NAME, category, UNITS, TAGS)

                except Exception as e:
                    print e
                    pass

    else:
        raise ValueError('Please refer to commandline arguments')


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
    value = root.find("./pod[@title='Date formats']").find('subpod').find('plaintext').text

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

    print value

    m = __number_re.search(value)

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

            dt = dateparse(value)

            QUANTITY = (dt - datetime.datetime(1970, 1, 1)).total_seconds()

            UNIT = "date"

        except:
            raise NameError('Could not parse!')

    return (QUANTITY, UNIT)


def get_image(NAME, TAGS):

    NAME = NAME.encode('utf-8')

    image_url = image_query(NAME)

    photo = ''

    if image_url:
        photo = "http://" + image_url


    elif "city" in TAGS and not photo:
        country = [x.strip() for x in NAME.split(',')][-1]
        countryItems = GameItem.Query.filter(name=country).limit(1)
        for countryItem in countryItems:
            if (countryItem.photoURL):
                photo = countryItem.photoURL
                print "FOUND THE URL! " + photo
                break

    return photo

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
  

def single_query(query_string,NAME, CATEGORY, UNITS="", TAGS=[]):

    QUERY = urllib.quote(query_string % NAME)

    BUILT_QUERY = QUERYSTRING % (QUERY, APP_ID)

    xml = urllib2.urlopen(BUILT_QUERY).read()
    root = ElementTree.fromstring(xml)

    print root

    TOPIC = get_topic(root)
    topicItems = [x.strip() for x in TOPIC.split(',')]
    if len(topicItems)>2:
        TOPIC = topicItems[0] + ", " + topicItems[-1]
        NAME = TOPIC

    PHOTO = get_image(NAME,TAGS)

    UNIT = ''
    QUANTITY = -1

    # assume we are just looking for the image
    if CATEGORY == "image":

        value = root.find("./pod[@title='Image']").find('markup').text
        m = __image_re.search(value)
        if m:
            PHOTO = "http://" + m.group(1)

    elif CATEGORY == "age":

        QUANTITY, UNIT = parse_age(QUERY, root)

    elif CATEGORY == "population":

        QUANTITY, UNIT = parse_population(QUERY, root)

    elif CATEGORY == "height":

        QUANTITY, UNIT = parse_height(QUERY, root)

    elif CATEGORY == "weight":

        QUANTITY, UNIT = parse_weight(QUERY, root)

    else:

        QUANTITY, UNIT = parse(root, UNITS)

    ############## PARSE API ##############

    kv = GameItem(category=CATEGORY, tagArray=TAGS, name=NAME, quantity=QUANTITY, unit=UNIT, photoURL=PHOTO)
    print "Finished " + NAME
    kv.save()

    ############## End PARSE API ##############


if __name__ == "__main__":
    main()