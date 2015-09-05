#!/usr/bin/env python
from bit9module import *
from cbmodule import *
from cmd import Cmd
from clint.textui import colored
import os,argparse
from launchmodule import *

def get_user_input():
    userinput=raw_input("y/n/q: ")

    if userinput=="y":
        result=True

    if userinput=="n":
        result=False

    if userinput=="q":
        print colored.red("[-] We aren't done yet, come baaaack!")
        sys.exit()
    return result


def srs_malicious_events():
    print colored.magenta("[?] How many most recent alerts would you like to view?")
    limit=raw_input("10/20/30/40/etc. ")
    events=bit9.event("subtype", str(1201), limit)
    print colored.green("[+] Checking Malicious File Alerts.")
    for event in events:
        if event['description'].endswith(" was identified by Bit9 Software Reputation Service as a malicious file."):
            print colored.red("[-] "+event['description'])
            match = re.match(r"^.*\[(.*)\].*$",event['description'])
            sha256=match.group(1)
            hashstate=bit9.check_hash("sha256", sha256)
            bit9.eval_hash_state(hashstate, event)
    print colored.green("[+] Our work here is done, check again soon.")

def srs_potential_risk_events():
    print colored.magenta("[?] How many most recent alerts would you like to view?")
    limit=raw_input("10/20/30/40/etc. ")
    events=bit9.event("subtype", str(1200), limit)
    print colored.green("[+] Checking Potential Risk Alerts.")
    for event in events:
        if event['description'].endswith(" was identified by Bit9 Software Reputation Service as a potential risk."):
            print colored.red("[-] "+event['description'])
            match = re.match(r"^.*\[(.*)\].*$",event['description'])
            sha256=match.group(1)
            hashstate=bit9.check_hash("sha256", sha256)
            bit9.eval_hash_state(hashstate,event)
    print colored.green("[+] Our work here is done, check again soon.")


def fireye_malicious_events():
    #NOT FINISHED
    events=bit9.event("subtype", str(1200), limit)
    print colored.green("[+] Checking FireEye Malicious File Alerts.")
    for event in events:
        if event['description'].endswith(" was identified by FIREEYE."):
            print colored.red("[-] "+event['description'])
            match = re.match(r"^.*\[(.*)\].*$",event['description'])
            md5=match.group(1)


def hash_lookup(hashvalue):
    #used for getting hash state info
    #if it exists, prompt to ban, if it does not, prompt to ban pre-emptively
    if len(hashvalue)==32:
        print colored.yellow("[*] MD5 Detected.")
        hashtype="md5"
    if len(hashvalue)==40:
        print colored.yellow("[*] SHA-1 Detected.")
        hashtype="sha1"
    if len(hashvalue)==64:
        print colored.yellow("[*] SHA-256 Detected.")
        hashtype="sha256"
    
    print colored.yellow("[*] Checking "+str(hashvalue))
    hashstate=bit9.check_hash(hashtype, hashvalue)
    if len(hashstate)==0:
        print colored.cyan("[?] Hash not found in Bit9.")
        cb.check_execution(str(hashvalue))
        pass

    else:
        if hashstate[0]['effectiveState']!='Banned':
            print colored.yellow("[*] Hash is not Banned")
            cb.check_execution(hashstate[0]['md5'])
            print colored.cyan("https://www.virustotal.com/latest-report.html?resource="+str(hashstate[0]['sha256']))
            print colored.cyan("[i] Prevalence: "+str(hashstate[0]['prevalence']))
            print colored.cyan("[?] File Name: "+str(hashstate[0]['fileName']))
            print colored.cyan("[?] Path: "+str(hashstate[0]['pathName']))
            try:
                print colored.magenta("[?] "+str(hashstate[0]['fileName'])+" is not Banned, shall we?")
            except:
                print colored.yellow("[*] Can't print filename, strange characters.")
                pass
            userinput=get_user_input()
            if userinput==True:
                bit9.ban_hash(hashstate[0]['sha256'], hashstate[0]['fileName'])
            if userinput==False:
                print colored.yellow("[*] Okay then, not banning the hash.")

            if hashstate[0]['publisherState']>0:
                print colored.magenta("[?] "+hashstate[0]['fileName']+" also has a publisher, "+hashstate[0]['publisher']+" shall we Ban it?")
                userinput=get_user_input()
                if userinput==True:
                    bit9.ban_certificate(hashstate)

                if userinput==False:
                    print colored.yellow("[*] Okay then, not banning the Certificate.")
        else:
            print colored.yellow("[*] Hash is banned.")
            print colored.magenta("[?] Check Carbon Black?")
            userinput=get_user_input()
            if userinput==True:
                cb.check_execution(hashstate[0]['md5'])

class gladiusprompt(Cmd):

    def do_0(self, args):
        print colored.red("[-] Thanks for all the fish...")
        raise SystemExit

    def do_1(self, args):
        #check X amount of most recent SRS 'Malicious File' events
        srs_malicious_events()
        launch.show_logo4()

    def do_2(self, args):
        #check X amount of most recent SRS 'Potential Risk File' events
        srs_potential_risk_events()
        launch.show_logo4()

    #NOT FINISHED
    def do_3(self, args):
        #check X amount of most recent FireEye 'Malicious File' events
        fireye_malicious_events()
        launch.show_logo4()

    def do_4(self, args):
        #check your environment for a single hash or a text file of newline seperated hashes
        print colored.magenta("[?] Hash(1) or Text File(2) ?: ")
        userinput=int(raw_input())
        if userinput==1:
            print colored.magenta("[?] Paste in the MD5, SHA-1 or SHA256 hash:")
            hashuserinput=raw_input()
            hash_lookup(hashuserinput.rstrip())

        if userinput==2:
            print colored.magenta("[+] Enter path of text file location: ")
            userfilepath=raw_input()
            if os.path.isfile(os.path.abspath(userfilepath)) == False:
                print colored.red("[-] "+userfilepath+" does not exist")
            else:
                for hashvalue in open(userfilepath):
                    hash_lookup(hashvalue.rstrip())
        launch.show_logo4()

    #NOT FINISHED
    def do_5(self, args):
        #check your environment for the publisherName of a certificate
        get_certificate_state()
        launch.show_logo4()

if __name__ == '__main__':
    launch=launchModule()
    if len(sys.argv) == 1:
        launch.show_logo4()
        print colored.yellow("usage: ")+colored.magenta("usage: ./gladius.py -c server-info.config\n")
        sys.exit()

    prompt=gladiusprompt()
    args = launch.get_args()


    cbserverurl,cbapitoken,b9serverurl,b9apitoken=launch.load_cb_config(args.configfile)

    cb=CB(cbserverurl, cbapitoken)
    bit9=Bit9(b9serverurl,b9apitoken,cb)

    launch.show_logo2()
    prompt.prompt = 'Gladius>'
    prompt.cmdloop()