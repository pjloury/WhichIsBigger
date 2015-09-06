#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

from xml.etree import cElementTree as ElementTree
import urllib2,urllib
import os
import pickle
import argparse
import re
import csv
import sys
import time

from parse_rest.connection import register
from parse_rest.datatypes import Object

from api_keys import *

pattern = '%m/%d/%Y'

__topic_re = re.compile("""(.*)\s+\|""")
__topic_re1 = re.compile("""(.*)\s+\(""")

__birthday_re = re.compile("""(\d+/\d+/\d+)""")
__height_re = re.compile("""(.*)\s+(meters)""")
__person_height_re = re.compile(r"""(\d+)\'\s+(\d+)""")

__population_re = re.compile(r"""([0-9.]+)\s+(\w+)\s+people""")


__weight_re = re.compile("""(.*)\s+(lb)""")

__image_re = re.compile("""src=\"//(\S+)\?""")

__list_re = re.compile("""\d+\s+\|\s+([^\|]*)\s+\|""")


QUERYSTRING_IMAGE = "http://api.wolframalpha.com/v2/query?input=%s&appid=%s&format=plaintext,html"
QUERYSTRING = "http://api.wolframalpha.com/v2/query?input=%s&appid=%s"


############## WOLFRAM API ##############

register(APP_ID_KEY, REST_API_KEY)

class GameItem(Object):
    pass

class Enum(set):
    def __getattr__(self, name):
        if name in self:
            return name
        raise AttributeError

Category = Enum(["age", "weight", "height", "population", "none"])

query_string = ""
multiple_query_string = ""

pickled_objects = []
PICKLE_FILE = './Data/objects.pkl'

def correct():
    print "In the 'correct' method"
    all_items = GameItem.Query.all()

    for item in all_items:

        if hasattr(item,'tags') and item.tags != None:

            tag_cs = item.tags

            tag_array = tag_cs.split(',')

            item.tagArray = tag_array

            item.tags = None

        image_url = item.photoURL

        if 'http://' not in image_url and image_url != None and image_url != "":

            item.photoURL = 'http://'+image_url

        if image_url == 'http://':
            item.photoURL = None

        print item
        item.save()


def main():
    print "In the main method"

    global query_string
    global multiple_query_string

    parser = argparse.ArgumentParser(description='wolfram to parse backend service')

    parser.add_argument('--mode', dest='mode',
                       help='script mode')
    parser.add_argument('--category', dest='category',
                       help='category [age, weight, height]')
    parser.add_argument('--object', dest='object', nargs='+',
                       help='name of the object')
    parser.add_argument('--csv', type=file, dest='csvfile',
                       help='csv file to parse')

    args = parser.parse_args()
    
    print args

    # category = sys.argv[1]
    #
    # MODE = sys.argv[2]
    #
    # OBJECT = " ".join(sys.argv[3:])

    QUERY_STRINGS = {"age":'%s birthday',"weight":'%s weight',"height":'%s height',"none":'%s',"population":'%s population'}
    MULTIPLE_QUERY_STRINGS = {"age":'oldest %s',"weight":'heaviest %s',"height":'tallest %s',"none":'%s',"population":"none"}

    category = args.category
    MODE = args.mode

    OBJECT = ''

    if args.object:
        OBJECT = ' '.join(args.object)
    csvfile = args.csvfile

    if csvfile:

        print "loading csv"

        reader = csv.reader(csvfile)

        for row in reader:
            print "reading a row"
            if len(row) < 2:
                continue

            OBJECT = row[0]
            TAGS = row[1]

            #check for existing parse entry
            exists = GameItem.Query.all().filter(name=OBJECT)
            if len(exists) > 0:
                print "Duplicate found"
                continue

            TAGS = [t.lower() for t in TAGS.split(',')]

            if "celebrity" in TAGS:

                categories = ["age","height"]

            elif "athlete" in TAGS:

                categories = ["age","height","weight"]

            elif "person" in TAGS:

                categories = ["age","weight"]

            elif "tall structure" in TAGS:

                categories = ["height"]

            elif "country" in TAGS:

                categories = ["population"]

            elif "city" in TAGS:

                categories = ["population"]

            elif "state" in TAGS:

                categories = ["population"]

            for CATEGORY in categories:

                #gracefully catch exception and move to next query
                try:
                    query_string = QUERY_STRINGS[CATEGORY]
                    single_query(OBJECT,CATEGORY,TAGS)
                except:
                    pass

    elif category and MODE and OBJECT:

        if category == "age":
            CATEGORY = Category.age
        elif category == "weight":
            CATEGORY = Category.weight
        elif category == "height":
            CATEGORY = Category.height
        elif category == "population":
            CATEGORY = Category.population
        elif category == "none":
            CATEGORY = Category.none

        #query_string = %s string
        query_string = QUERY_STRINGS[category]
        multiple_query_string = MULTIPLE_QUERY_STRINGS[category]

        #what is multiple vs aggregate?
        if MODE == "multiple":
            objects = collection_query(OBJECT)

            for obj in objects:
                single_query(obj,CATEGORY)

        #aggregate -> get age and height for specificed object
        elif MODE == "aggregate":

            for CATEGORY in ["age","weight","height"]:
                query_string = QUERY_STRINGS[CATEGORY]
                single_query(OBJECT,CATEGORY)

        else:
            single_query(OBJECT,CATEGORY)

    else:
        raise ValueError('Please refer to commandline arguments')

#
def collection_query(TOPIC):

    QUERY = multiple_query_string % TOPIC

    BUILT_QUERY = QUERYSTRING % (QUERY.replace(' ','%20'),APP_ID)

    xml = urllib2.urlopen(BUILT_QUERY).read()

    print xml

    root = ElementTree.fromstring(xml)

    text = root.find("./pod[@title='Result']").find('subpod').find('plaintext').text

    results = []

    for line in text.split('\n'):

        m = __list_re.match(line)

        if m:
            results.append(m.group(1))

    return results


def get_topic(root):

    topic = root.find("./pod[@title='Input interpretation']").find('subpod').find('plaintext').text

    m = __topic_re.match(topic)

    if m:
        return m.group(1)
    else:

        m = __topic_re1.match(topic)

        if m:
            return m.group(1)

        raise NameError('Error parsing topic')


def image_query(object):

    object = object.encode('utf-8')

    QUERY = urllib.quote(object)

    BUILT_QUERY = QUERYSTRING_IMAGE % (QUERY,APP_ID)

    # if os.path.exists(PICKLE_PATH):
    #     xml = pickle.load(open(PICKLE_PATH,'rb'))
    #
    # else:
    #     xml = urllib2.urlopen(BUILT_QUERY).read()
    #     pickle.dump(xml,open(PICKLE_PATH,'wb'))

    xml = urllib2.urlopen(BUILT_QUERY).read()
    #print xml

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


def single_query(object,CATEGORY,TAGS=[]):

    #ensure all non-ascii characters are converted to html entities
    #OBJECT = OBJECT.encode("ascii", "xmlcharrefreplace")

    PHOTO = ''
    object = object.encode('utf-8')
    image_url = image_query(object)
    if image_url:
        PHOTO = "http://"+image_url

    QUERY = urllib.quote(query_string % object)

    BUILT_QUERY = QUERYSTRING % (QUERY,APP_ID)

    # if os.path.exists(PICKLE_PATH):
    #     xml = pickle.load(open(PICKLE_PATH,'rb'))
    #
    # else:
    #     xml = urllib2.urlopen(BUILT_QUERY).read()
    #     pickle.dump(xml,open(PICKLE_PATH,'wb'))

    xml = urllib2.urlopen(BUILT_QUERY).read()
    #print xml

    root = ElementTree.fromstring(xml)

    # print ElementTree.tostring(root)

    # for child in root:
    #     print child.tag, child.attrib

    TOPIC = get_topic(root)

    UNIT = ''
    QUANTITY = -1


    if CATEGORY == Category.none:

        value = root.find("./pod[@title='Image']").find('markup').text
        m = __image_re.search(value)
        if m:
            PHOTO = "http://"+m.group(1)


    elif CATEGORY == Category.age:

        value = root.find("./pod[@title='Date formats']").find('subpod').find('plaintext').text

        if "month/day/year" in value:

            m = __birthday_re.match(value)

            if m:
                QUANTITY = m.group(1)

                #convert scientifc notation to number
                QUANTITY = int(time.mktime(time.strptime(QUANTITY, pattern)))

                UNIT = "date"
            else:
                raise NameError('No match for birthday query')

        else:
            raise NameError('No results found for query: %s' % QUERY)

    elif CATEGORY == Category.population:

        value = root.find("./pod[@title='Result']").find('subpod').find('plaintext').text

        if "people" in value:

            m = __population_re.match(value)

            if m:
                QUANTITY = float(m.group(1))

                modifier = m.group(2)

                if modifier == "million":
                    QUANTITY = QUANTITY*float(10**6)
                elif modifier == "billion":
                    QUANTITY = QUANTITY*float(10**9)

                #convert scientifc notation to number
                UNIT = "people"
            else:
                raise NameError('No match for population query')

        else:
            raise NameError('No results found for query: %s' % QUERY)

    elif CATEGORY == Category.height:

        result = root.find("./pod[@title='Result']").find('subpod').find('plaintext').text
        print result

        m = __person_height_re.match(result)

        if m:
            QUANTITY = int(m.group(1))*12 + int(m.group(2))

            UNIT = "inches"

        else:

            subpods = root.find("./pod[@title='Unit conversions']")

            result_found = False

            if subpods:
                for subpod in subpods:
                    value = subpod.find('plaintext').text

                    if " meters" in value:

                        m = __height_re.match(value)

                        if m:
                            QUANTITY = m.group(1)

                            #convert scientifc notation to number
                            QUANTITY = float(QUANTITY.replace(u"�10^","E+").replace('~',''))

                            UNIT = m.group(2)
                            result_found = True
                            break
                        else:
                            raise NameError('No match for height query')


            else:
                raise NameError('No results found for query: %s' % QUERY)
            if not result_found:
                raise NameError('No match for height query')


    elif CATEGORY == Category.weight:

        result = root.find("./pod[@title='Result']").find('subpod').find('plaintext').text

        m = __weight_re.match(result)

        if m:
            QUANTITY = m.group(1)

            #convert scientifc notation to number
            QUANTITY = float(QUANTITY.replace(u"�10^","E+").replace('~',''))

            UNIT = m.group(2)

        else:

            subpods = root.find("./pod[@title='Unit conversions']").find('plaintext').text

            result_found = False

            if subpods:

                for subpod in subpods:

                    value = subpod.find('plaintext').text

                    if " pounds" in value:

                        m = __weight_re.match(value)

                        if m:
                            QUANTITY = m.group(1)

                            #convert scientifc notation to number
                            QUANTITY = float(QUANTITY.replace(u"�10^","E+").replace('~',''))

                            UNIT = m.group(2)
                            result_found = True
                            break
                        else:
                            raise NameError('No match for weight query')

            else:
                raise NameError('No results found for query: %s' % QUERY)

            if not result_found:
                raise NameError('No match for height query')

    ############## PARSE API ##############

    kv = GameItem(category=CATEGORY, tagArray=TAGS, name=TOPIC, quantity=QUANTITY, unit=UNIT, photoURL=PHOTO)
    print "Finished " + TOPIC
    kv.save()

if __name__ == "__main__":
    main()