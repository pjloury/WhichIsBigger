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

Category = Enum(["age", "weight", "height","none"])

query_string = ""
multiple_query_string = ""

pickled_objects = []
PICKLE_FILE = '/Users/admin/Documents/WhichIsBigger/BackendServices/Data/objects.pkl'

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
        # break


def main():
    print "In the main method"

    global query_string
    global multiple_query_string

    parser = argparse.ArgumentParser(description='wolfram to parse backend service')

    parser.add_argument('--mode', type=int, dest='mode',
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

    QUERY_STRINGS = {"age":'%s birthday',"weight":'%s weight',"height":'%s height',"none":'%s'}
    MULTIPLE_QUERY_STRINGS = {"age":'oldest %s',"weight":'heaviest %s',"height":'tallest %s',"none":'%s'}

    category = args.category
    MODE = args.mode

    if args.object:
        OBJECT = ' '.join(args.object)
    csvfile = args.csvfile

    if category and MODE and OBJECT:

        if category == "age":
            CATEGORY = Category.age
        elif category == "weight":
            CATEGORY = Category.weight
        elif category == "height":
            CATEGORY = Category.height
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
        elif MODE == "aggregate":
            for CATEGORY in ["age","height"]:
                query_string = QUERY_STRINGS[CATEGORY]
                single_query(OBJECT,CATEGORY)
        else:
            single_query(OBJECT,CATEGORY)

    elif csvfile:

        if os.path.exists(PICKLE_FILE):
            pickled_objects = pickle.load(open(PICKLE_FILE,'r'))

        else:
            pickled_objects = []

        print "loading csv"

        reader = csv.reader(csvfile)

        for row in reader:

            if len(row) < 2:
                continue

            OBJECT = row[0]
            TAGS = row[1]

            if OBJECT not in pickled_objects:

                pickled_objects.append(OBJECT)

                print TAGS

                TAGS = TAGS.split(',')

                if "person" in TAGS.lower():

                    categories = ["age","height","weight"]

                elif "tall structure" in TAGS.lower():

                    categories = ["height"]


                for CATEGORY in categories:

                    #gracefully catch exception and move to next query
                    try:

                        query_string = QUERY_STRINGS[CATEGORY]
                        single_query(OBJECT,CATEGORY,TAGS)

                    except:
                        pass

                pickle.dump(pickled_objects,file=open(PICKLE_FILE,'w+'))

    else:
        raise ValueError('Please refer to commandline arguments')

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


    print xml

    root = ElementTree.fromstring(xml)


    image_node = root.find("./pod[@title='Image']")

    if image_node:
        value = image_node.find('markup').text

        m = __image_re.search(value)

        if m:
            return m.group(1)
        else:
            return None

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
    print xml

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
                            QUANTITY = float(QUANTITY.replace(u"×10^","E+").replace('~',''))

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
            QUANTITY = float(QUANTITY.replace(u"×10^","E+").replace('~',''))

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
                            QUANTITY = float(QUANTITY.replace(u"×10^","E+").replace('~',''))

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
    kv.save()

if __name__ == "__main__":
    main()