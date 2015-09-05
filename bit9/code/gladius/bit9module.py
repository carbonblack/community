import requests,json,re,sys
from clint.textui import colored
from cbmodule import *

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

class Bit9(object):

    def __init__(self, serverurl, apitoken,cb):

        self.cb = cb
        self.b9StrongCert = True
        self.apitoken=apitoken
        self.serverurl=serverurl+str("/api/bit9platform/v1/")
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
        try:
            print colored.green("[+] "+str(rulename)+" "+str(hashvalue)+" Banned!")
        except:
            print colored.yellow("[*] Can't print strange characters, need to learn 2 codec")
            pass



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
    def eval_hash_state(self, hashstate, event):
        if hashstate[0]['effectiveState']!='Banned':
            print colored.yellow("[*] Hash is not Banned")
            self.cb.check_execution(hashstate[0]['md5'])
            print colored.cyan("https://www.virustotal.com/latest-report.html?resource="+str(hashstate[0]['sha256']))
            print colored.cyan("[i] Prevalence: "+str(hashstate[0]['prevalence']))
            try:
                print colored.cyan("[i] Path: "+str(event['pathName']))
            except:
                print colored.yellow("[*] Can't print out path, probably some character encoding issues...")
                print event
                pass
            print colored.cyan("[i] Hostname: "+str(event['computerName']))             

            try:
                print colored.magenta("[?] "+str(hashstate[0]['fileName'])+" is not Banned, shall we?")
            except:
                print colored.yellow("[*] Can't print filename, strange characters.")
                pass
            userinput=get_user_input()
            if userinput==True:
                self.ban_hash(hashstate[0]['sha256'], hashstate[0]['fileName'])
            if userinput==False:
                print colored.yellow("[*] Okay then, not banning the hash.")

            if hashstate[0]['publisherState']>0:
                print colored.magenta("[?] "+hashstate[0]['fileName']+" also has a publisher, "+hashstate[0]['publisher']+" shall we Ban it?")
                userinput=get_user_input()
                if userinput==True:
                    self.ban_certificate(hashstate)

                if userinput==False:
                    print colored.yellow("[*] Okay then, not banning the Certificate.")
        else:
            if hashstate[0]['fileName']==None:
                print colored.yellow("[*] Hash "+str(hashstate[0]['sha256'])+" is Banned but has no File Name, "+"https://www.virustotal.com/latest-report.html?resource="+str(hashstate[0]['sha256']))
            else:
                try:
                    print colored.yellow("[*] "+str(hashstate[0]['fileName'])+" is "+hashstate[0]['effectiveState']+", https://www.virustotal.com/latest-report.html?resource="+str(hashstate[0]['sha256']))
                except:
                    print colored.yellow("[*] Strange characters, can't print.")
                    pass

