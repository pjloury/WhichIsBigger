#!/usr/bin/env python

from xml.etree import cElementTree as ElementTree
import urllib2
import os
import pickle
import re

############## WOLFRAM API ##############

category = sys.argv[1]
obj = sys.argv[2]

__age_re = re.compile("""(\w+)\syears""")

QUERYSTRING = "http://api.wolframalpha.com/v2/query?input=%s&appid=%s"
APP_ID = os.environ['WOLFRAM_APP_KEY']
PICKLE_PATH = './xml.pkl'

REST_API_KEY = os.environ['PARSE_REST_KEY']
APP_ID_KEY = os.environ['PARSE_API_KEY']

class Enum(set):
    def __getattr__(self, name):
        if name in self:
            return name
        raise AttributeError

Category = Enum(["age", "weight", "height"])

if category == "age":
    CATEGORY = Category.age
elif category == "weight":
    CATEGORY = Category.weight
elif category == "height":
    CATEGORY = Category.height

OBJECT = obj

if CATEGORY == Category.age:
    query_string = 'how old is %s'
elif CATEGORY == Category.weight:
    query_string = 'how much does %s weigh'
elif CATEGORY == Category.height:
    query_string = 'how tall is %s'

QUERY = query_string % OBJECT

BUILT_QUERY = QUERYSTRING % (QUERY.replace(' ','%20'),APP_ID)

if os.path.exists(PICKLE_PATH):
	xml = pickle.load(open(PICKLE_PATH,'rb'))

else:
    xml = urllib2.urlopen(BUILT_QUERY).read()
    pickle.dump(xml,open(PICKLE_PATH,'wb'))


root = ElementTree.fromstring(xml)

# print ElementTree.tostring(root)

# for child in root:
#     print child.tag, child.attrib


UNIT = ''
QUANTITY = -1

results = root.findall("./pod[@title='Result'][@scanner='Age']")

if len(results) > 0:
    value = results[0].find('subpod').find('plaintext').text

    if CATEGORY == Category.age:
        m = __age_re.match(value)

        if m:
            QUANTITY = int(m.group(1))
            UNIT = 'years'
        else:
            raise NameError('No match for age query')

else:
    raise NameError('No results found for query: %s' % QUERY)


############## PARSE API ##############

from parse_rest.connection import register
from parse_rest.datatypes import Object

register(APP_ID_KEY, REST_API_KEY)

class GameItem(Object):
    pass

kv = GameItem(category=CATEGORY, name=OBJECT, quantity=QUANTITY, unit=UNIT)

kv.save()