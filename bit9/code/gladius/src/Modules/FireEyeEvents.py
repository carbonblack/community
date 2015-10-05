import re
from clint.textui import colored
from Bit9.Events import Events
from Bit9.CheckHash import CheckHash
from Modules.EvalHashState import EvalHashState

class FireEyeEvents(object):
    
    def __init__(self, limit):
        self.limit=limit
        fireeye_events=Events.Run("subtype", str(1201), self.limit)
        print colored.green("[+] Checking FireEye Malicious File Alerts.")
        for event in fireeye_events:
            if event['stringId']==3521:
                print colored.red("[-] "+event['description'])
                match = re.match(r"^.*\[(.*)\].*$",event['description'])
                md5=match.group(1)
                hashstate=CheckHash.Run("md5", md5)
                EvalHashState.Run(hashstate, event)
        print colored.green("[+] Our work here is done, check again soon.")