#!/usr/bin/env python2

import json
import uuid
from redis import StrictRedis

def to_int(s):
  try:
    return int(s)
  except ValueError:
    return None

def wait_for_message(correlId):
    for msg in pubsub.listen():
        if msg['type'] != 'message':
            continue
        data = json.loads(msg['data'])
        if data['correlId'] == correlId:
 	   return data

redis = StrictRedis()
pubsub = redis.pubsub()
levels = {}

correlId = str(uuid.uuid4())
pubsub.subscribe('hopper-response')
redis.publish('hopper-request', json.dumps({
    "cmd": "get-all-levels",
    "msgId": correlId
}))

msg = wait_for_message(correlId)
levels = {int(level['value']): int(level['level']) for level in msg['levels']}


print("Welcome to kassomat maintenance mode!\n")
print("The following coins are in the machine:\n")
for value, count in levels.items():
    print("%d x %d Eurocent" % (value, count))
print("""
Please enter the desired coin value.
 - empty line to quit
 - raw numbers to add coins.
 - prefix "-" to remove coins.
 - prefix "=" to set an absolute amount of coins
""")

while True:
    raw_value = raw_input("coin value: ")
    if raw_value == '':
	break
    value = to_int(raw_value)
    if not value or value not in levels.keys():
	print("invalid value, valid are:",
	  ", ".join([str(k) for k in levels.keys()]))
	continue

    raw_count = raw_input("count: ")
    
    if len(raw_count) > 1 and raw_count[0] in ('-', '='):
        operator = raw_count[0]
        raw_count = raw_count[1:]
    else:
        operator = None

    if raw_count == '':
	break
    count = to_int(raw_count)
    if not count:
	print("invalid count, please enter an integer.")
	continue

    if operator == '=':
        levels[value] = count
    elif operator == '-':
        absolute = levels[value] - count
        levels[value] = absolute if absolute > 0 else 0
    else:
        levels[value] = levels[value] + count

    print("new: %d x %d Eurocent" % (value, levels[value]))

    
print("Sending the following values to the machine:")
for value, count in levels.items():
    correlId = str(uuid.uuid4()) 
    redis.publish('hopper-request', json.dumps({
      "cmd": "set-denomination-level",
      "msgId": correlId,
      "amount": value,
      "level": count
    }))
    msg = wait_for_message(correlId)
    status = 'success' if msg['result'] == 'ok' else 'error'
    print("%d x %d Eurocent: %s" % (value, levels[value], status))

print("Bye.")
