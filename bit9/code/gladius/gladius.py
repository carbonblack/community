#!/usr/bin/env python
import requests,json,sys,re
from cmd import Cmd
from clint.textui import colored
#pip install clint

class Bit9(object):

    def __init__(self):

        self.b9StrongCert = True
        self.apitoken="YOUR-API-TOKEN-HERE"
        self.serverurl="YOUR-SERVER-URL-HERE.com/api/bit9platform/v1/"
        self.authJson={
         'X-Auth-Token': self.apitoken, 
         'content-type': 'application/json'
                      } 

        self.eventurl=self.serverurl+"event"
        self.md5url = self.serverurl+"fileCatalog?q=md5:"
        self.sha256url = self.serverurl+"fileCatalog?q=sha256:"
        self.fileruleurl = self.serverurl+"fileRule"
        self.computernameurl=self.serverurl+"computer?q=name:"
        self.computerurl=self.serverurl+"Computer/"
        self.pathnameurl=self.serverurl+"fileInstanceGroup?q=pathName:"
        self.certificateurl=self.serverurl+"publisher/"


    def ban_hash(self, hashvalue, rulename):
        print colored.yellow("[*] Banning "+ hashvalue+"...")
        data = {'hash': hashvalue, 'fileState': 3, 'policyIds': '0', 'name': rulename}
        r = requests.post(self.fileruleurl, json.dumps(data), headers=self.authJson, verify=self.b9StrongCert)
        r.raise_for_status()      
        fileRule = r.json()
        print colored.green("[+] "+rulename+" "+hashvalue+" Banned!")


    def ban_certificate(self, hashstate):
        print colored.yellow("[*] Banning certificate for "+hashstate[0]['publisher']+"...")
        data = {'publisherState': 3}
        r = requests.put(self.certificateurl+str(hashstate[0]['publisherId']), json.dumps(data), headers=self.authJson, verify=self.b9StrongCert)
        r.raise_for_status()      
        fileRule = r.json() 
        print colored.green("[+] "+hashstate[0]['publisher']+" certificate has been Banned!")               


    def find_computer(self, computername):
        r = requests.get(self.computernameurl+computername, headers=self.authJson, verify=self.b9StrongCert)
        r.raise_for_status()
        result = r.json()
        return result


    def tag_computer(self, computername, description, computertag):
        result = self.find_computer(computername)
        computerid = str(result[0]['id'])

        data = {'description':description, 'computerTag': computertag}
        r = requests.put(self.computerurl+computerid, json.dumps(data), headers=self.authJson, verify=self.b9StrongCert)
        r.raise_for_status()
        result = r.json()

    #not finished    
    def computer_with_path(self, pathname):
        r = requests.get(self.pathnameurl+pathname, headers=self.authJson, verify=self.b9StrongCert)
        r.raise_for_status()
        result = r.json()
        print result   


    def check_hash(self,hashtype,value):
        if hashtype=="md5":
            hashurl=self.md5url

        if hashtype=="sha1":
            hashurl=self.sha1url

        if hashtype=="sha256":
            hashurl=self.sha256url

        r = requests.get(hashurl+value, headers=self.authJson, verify=self.b9StrongCert)
        r.raise_for_status()
        result = r.json()
        return result


    def event(self, term, value, limit):
        r = requests.get(self.eventurl+"?q="+term+":"+value+"&limit="+limit+"&sort=receivedTimestamp%20DESC", headers=self.authJson, verify=self.b9StrongCert)
        r.raise_for_status()
        result = r.json()
        return result

    #evaluate current state of a hash, check its effectiveState, prompt to be banned if not, prompt for publisher ban if it has one
    def eval_hash_state(self, hashstate):
        if hashstate[0]['effectiveState']!='Banned':
            print colored.cyan("https://www.virustotal.com/latest-report.html?resource="+str(hashstate[0]['md5']))             
            print colored.magenta("[?] "+hashstate[0]['fileName']+" is not Banned, shall we?")
            userinput=get_user_input()
            if userinput==True:
                bit9.ban_hash(hashstate[0]['md5'], hashstate[0]['fileName'])
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
            if hashstate[0]['fileName']==None:
                print colored.yellow("[*] Hash "+str(hashstate[0]['md5'])+" is Banned but has no File Name, "+"https://www.virustotal.com/latest-report.html?resource="+str(hashstate[0]['md5']))
            else:
                print colored.yellow("[*] "+hashstate[0]['fileName']+" is "+hashstate[0]['effectiveState']+", https://www.virustotal.com/latest-report.html?resource="+str(hashstate[0]['md5']))



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
            bit9.eval_hash_state(hashstate)
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
            bit9.eval_hash_state(hashstate)
    print colored.green("[+] Our work here is done, check again soon.")

#not finished
def fireye_malicious_events():
    events=bit9.event("subtype", str(1200), limit)
    print colored.green("[+] Checking FireEye Malicious File Alerts.")
    for event in events:
        if event['description'].endswith(" was identified by Bit9 Software Reputation Service as a potential risk."):
            print colored.red("[-] "+event['description'])
            match = re.match(r"^.*\[(.*)\].*$",event['description'])
            md5=match.group(1)

#used for getting hash state info
def get_hash_state():
    print colored.magenta("[?] Paste in the MD5, SHA-1 or SHA256 hash:")
    hashvalue=raw_input().strip(" ")
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
        print colored.yellow("[-] Hash does not exist in our envirnment")
        print colored.magenta("[?] Would you like to ban this Hash?")
        userinput=get_user_input()
        if userinput==True:
            bit9.ban_hash(hashvalue,"Pre-emptive Hash Ban")
        if userinput==False:
            print colored.yellow("[*] Okay, not banning the Hash.")
    else:
        bit9.eval_hash_state(hashstate)
        print colored.green("[+] Hash checking complete.")


def show_logo2():

    print colored.cyan("""
           |`-._/\_.-`|    1 = 'Malicious File'
           |    ||    |    2 = 'Potential Risk File'
           |___o()o___|    3 = FireEye 'Malicious File'
           |__((<>))__|    4 = Hash
           \   o\/o   /    5 = Certificate
            \   ||   /     0 = Quit
             \  ||  /      
              '.||.'       noah.corradin
                ``

        """)


class gladiusprompt(Cmd):

    def do_0(self, args):
        print colored.red("[-] Thanks for all the fish...")
        raise SystemExit

    def do_1(self, args):
        srs_malicious_events()
        show_logo2()

    def do_2(self, args):
        srs_potential_risk_events()
        show_logo2()

    #not finished
    def do_3(self, args):
        fireye_malicious_events()
        print "I'm doin2"

    def do_4(self, args):
        get_hash_state()
        show_logo2()

    #not finished    
    def do_5(self, args):
        get_certificate_state()
        print "I'm doin2"

if __name__ == '__main__':
    prompt=gladiusprompt()
    bit9=Bit9()
    show_logo2()
    prompt.prompt = 'Gladius>'
    prompt.cmdloop()