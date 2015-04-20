#!/usr/bin/env python
# -*- coding: iso-8859-15 -*-

from xml.etree import cElementTree as ElementTree
import urllib2
import os
import pickle
import re

import sys

from parse_rest.connection import register
from parse_rest.datatypes import Object


from api_keys import *


import time

pattern = '%m/%d/%Y'

__topic_re = re.compile("""(.*)\s+\|""")
__birthday_re = re.compile("""(\d+/\d+/\d+)""")
__height_re = re.compile("""(.*)\s+(meters)""")
__weight_re = re.compile("""(.*)\s+(lb)""")

############## WOLFRAM API ##############

register(APP_ID_KEY, REST_API_KEY)

class GameItem(Object):
    pass

class Enum(set):
    def __getattr__(self, name):
        if name in self:
            return name
        raise AttributeError

Category = Enum(["age", "weight", "height"])

query_string = ""


def main():

    global query_string

    category = sys.argv[1]

    OBJECT = " ".join(sys.argv[2:])


    if category == "age":
        CATEGORY = Category.age
        query_string = '%s birthday'
    elif category == "weight":
        CATEGORY = Category.weight
        query_string = '%s weight'
    elif category == "height":
        CATEGORY = Category.height
        query_string = '%s height'

    single_query(OBJECT,CATEGORY)


def get_topic(root):

    topic = root.find("./pod[@title='Input interpretation']").find('subpod').find('plaintext').text

    m = __topic_re.match(topic)

    if m:
        return m.group(1)
    else:
        raise NameError('Error parsing topic')

def single_query(OBJECT,CATEGORY):

    QUERY = query_string % OBJECT

    BUILT_QUERY = QUERYSTRING % (QUERY.replace(' ','%20'),APP_ID)

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


    if CATEGORY == Category.age:


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


        subpods = root.find("./pod[@title='Unit conversions']")

        result_found = False

        if subpods:

            for subpod in subpods:

                value = subpod.find('plaintext').text

                if "meters" in value:

                    m = __height_re.match(value)

                    if m:
                        QUANTITY = m.group(1)

                        #convert scientifc notation to number
                        QUANTITY = float(QUANTITY.replace(u"×10^","E+"))

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


        subpods = root.find("./pod[@title='Unit conversions']")

        result_found = False

        if subpods:

            for subpod in subpods:

                value = subpod.find('plaintext').text

                if "pounds" in value:

                    m = __weight_re.match(value)

                    if m:
                        QUANTITY = m.group(1)

                        #convert scientifc notation to number
                        QUANTITY = float(QUANTITY.replace(u"×10^","E+"))

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


    kv = GameItem(category=CATEGORY, name=TOPIC, quantity=QUANTITY, unit=UNIT)

    kv.save()


if __name__ == "__main__":
    main()