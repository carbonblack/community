import re
from clint.textui import colored
from Bit9.Events import Events
from Bit9.CheckHash import CheckHash
from Modules.EvalHashState import EvalHashState

class PotentialRiskFileEvents(object):
    
    def __init__(self, limit):
        self.limit=limit
        malicious_file_events=Events.Run("subtype", str(1200), self.limit)
        print colored.green("[+] Checking Potential Risk File Alerts.")
        for event in malicious_file_events:
            if event['description'].endswith(" was identified by Bit9 Software Reputation Service as a potential risk."):
                print colored.red("[-] "+event['description'])
                match = re.match(r"^.*\[(.*)\].*$",event['description'])
                sha256=match.group(1)
                hashstate=CheckHash.Run("sha256", sha256)
                EvalHashState.Run(hashstate, event)
        print colored.green("[+] Our work here is done, check again soon.")