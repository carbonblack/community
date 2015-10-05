from cmd import Cmd
from Modules.MaliciousFileEvents import MaliciousFileEvents
from Modules.PotentialRiskFileEvents import PotentialRiskFileEvents
from Modules.FireEyeEvents import FireEyeEvents
from Modules.HashLookup import HashLookup
from Modules.ComputerLookup import ComputerLookup
from clint.textui import colored
from Launch.Launch import Launch
import os

        
class Prompt(Cmd):

    def do_0(self, args):
        print colored.red("[-] Thanks for all the fish...")
        raise SystemExit

    def do_1(self, args):
    #"""Go through your environments SRS 'Malicious File' Alerts.  
    #Check if the hash is banned, check if it was seen in Carbon Black,
    #prompt user to ban hash and/or certificate"""

        print colored.magenta("[?] How many most recent alerts would you like to view?")
        limit=raw_input("10/20/30/40/etc. ")
        MaliciousFileEvents(limit)
        Launch.show_logo2()

    def do_2(self, args):
    # """Go through your environments 'SRS Potential Risk File' Alerts.  
    # Check if the hash is banned, check if it was seen in Carbon Black,
    # prompt user to ban hash and/or certificate"""

        print colored.magenta("[?] How many most recent alerts would you like to view?")
        limit=raw_input("10/20/30/40/etc. ")
        PotentialRiskFileEvents(limit)
        Launch.show_logo2()

    def do_3(self, args):
    # """Go through your environments Fire Eye '[-] File INFO was identified by FireEye as malicious.' Alerts.  
    # Check if the hash is banned, check if it was seen in Carbon Black,
    # prompt user to ban hash and/or certificate"""

        print colored.magenta("[?] How many most recent alerts would you like to view?")
        limit=raw_input("10/20/30/40/etc. ")
        FireEyeEvents(limit)
        Launch.show_logo2()

    def do_4(self, args):
        #check your environment for a single hash or a text file of newline seperated hashes
        print colored.magenta("[?] Hash(1) or Text File(2) ?: ")
        userinput=int(raw_input())
        if userinput==1:
            print colored.magenta("[?] Paste in the MD5, SHA-1 or SHA256 hash:")
            hashuserinput=raw_input()
            HashLookup(hashuserinput.rstrip())

        if userinput==2:
            print colored.magenta("[+] Enter path of text file location: ")
            userfilepath=raw_input()
            if os.path.isfile(os.path.abspath(userfilepath)) == False:
                print colored.red("[-] "+userfilepath+" does not exist")
            else:
                for hashvalue in open(userfilepath):
                    HashLookup(hashvalue.rstrip())

        Launch.show_logo2()

    def do_5(self, args):
        #check your environment for the publisherName of a certificate
        
        get_certificate_state()
        launch.show_logo2()

    def do_6(self, args):
        #Check if computers from list have Bit9 and/or CB installed
        print colored.magenta("[+] Enter palth of text file: ")
        usercomputerfile=raw_input()
        if os.path.isfile(os.path.abspath(usercomputerfile)) == False:
            print colored.red("[-] "+usercomputerfile+" does not exist")
        else:  
            ComputerLookup(usercomputerfile)
        Launch.show_logo2()