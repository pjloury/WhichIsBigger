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


__age_re = re.compile("""(\w+)\syears""")
__height_re = re.compile("""(.*)\s(meters)""")
__weight_re = re.compile("""(.*)\s(lb)""")

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



def single_query(OBJECT,CATEGORY):

    QUERY = query_string % OBJECT

    BUILT_QUERY = QUERYSTRING % (QUERY.replace(' ','%20'),APP_ID)

    if os.path.exists(PICKLE_PATH):
        xml = pickle.load(open(PICKLE_PATH,'rb'))

    else:
        xml = urllib2.urlopen(BUILT_QUERY).read()
        pickle.dump(xml,open(PICKLE_PATH,'wb'))

    xml = urllib2.urlopen(BUILT_QUERY).read()


    print xml

    root = ElementTree.fromstring(xml)

    # print ElementTree.tostring(root)

    for child in root:
        print child.tag, child.attrib




    UNIT = ''
    QUANTITY = -1


    if CATEGORY == Category.age:


        results = root.findall("./pod[@title='Result'][@scanner='Age']")

        if len(results) > 0:
            value = results[0].find('subpod').find('plaintext').text

            m = __age_re.match(value)

            if m:
                QUANTITY = int(m.group(1))
                UNIT = 'years'
            else:
                raise NameError('No match for age query')


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

                if "(pounds)" in value:

                    m = __weight_re.match(value)

                    if m:
                        QUANTITY = m.group(1)

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


    kv = GameItem(category=CATEGORY, name=OBJECT, quantity=QUANTITY, unit=UNIT)

    kv.save()


if __name__ == "__main__":
    main()