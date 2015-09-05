import cbapi, sys
from clint.textui import colored
from bit9module import *

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

class CB(object):

    def __init__(self, cbserverurl,cbapitoken):
        self.serverurl=cbserverurl  
        self.apitoken=cbapitoken
        self.parentmd5url=self.serverurl+str("\#search/cb.urlver=1&cb.q.parent_md5=%20")
        self.md5url=self.serverurl+str("\#search/cb.urlver=1&cb.q.md5=%20")
        self.cb = cbapi.CbApi(self.serverurl,
             token=self.apitoken,
             ssl_verify=False)


    def check_execution(self, md5):
        parentquery='parent_md5:'+md5
        md5query='md5:'+md5

        if md5query.endswith(" "):
            print colored.red("[-] Bit9 did not capture the MD5 :(\n")
        else:
            print colored.yellow("[*] Checking if Parent MD5 process in Carbon Black...")
            parentresult = self.cb.process_search(parentquery, sort='start desc')
            if parentresult['total_results']==0:
                print colored.cyan("[+] Not a Parent MD5 process")
            else:
                cbparentmd5url=self.parentmd5url+md5+"&sort=&rows=10&start=0"
                print colored.green("[+] Parent MD5 event found in Carbon Black.")
                print colored.cyan(cbparentmd5url)
            print colored.yellow("[*] Checking if MD5 seen in Carbon Black...")
            md5result = self.cb.process_search(md5query, sort='start desc')
            if md5result['total_results'] == 0:
                print colored.cyan("[+] Not seen in Carbon Black.")
            else:
                cbmd5url=self.md5url+md5+"&sort=&rows=10&start=0"
                print colored.green("[+] MD5 Found in CB.")
                print colored.cyan(cbmd5url)

#cb=CB()