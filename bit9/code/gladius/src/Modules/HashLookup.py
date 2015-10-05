import re
from clint.textui import colored
from Bit9.Events import Events
from Bit9.CheckHash import CheckHash
from Modules.EvalHashState import EvalHashState

class HashLookup(object):
    
    def __init__(self, hashvalue):
        print colored.green("[+] Checking "+str(hashvalue))
        if len(hashvalue)==32:
            print colored.yellow("[*] MD5 Detected.")
            hashtype="md5"
        if len(hashvalue)==40:
            print colored.yellow("[*] SHA-1 Detected.")
            hashtype="sha1"
        if len(hashvalue)==64:
            print colored.yellow("[*] SHA-256 Detected.")
            hashtype="sha256"
        
        hashstate=CheckHash.Run(hashtype, hashvalue)
        if len(hashstate)==0:
            print colored.cyan("[?] Hash not found in Bit9.")
            cb.check_execution(str(hashvalue))
            pass
        EvalHashState.Run(hashstate, event=None)
        print colored.green("[+] Our work here is done, check again soon.")