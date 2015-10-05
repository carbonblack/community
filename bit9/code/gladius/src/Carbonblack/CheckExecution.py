import cbapi
from clint.textui import colored

class CheckExecution(object):

    @staticmethod
    def Run(md5):

        serverurl="https://minotaurus.autodesk.com:8443"
        apitoken="1320d247d2047aef8895521dfd46221b8fed703f"
        parentmd5url=serverurl+str("\#search/cb.urlver=1&cb.q.parent_md5=%20")
        md5url=serverurl+str("\#search/cb.urlver=1&cb.q.md5=%20")
        cb = cbapi.CbApi(serverurl,
             token=apitoken,
             ssl_verify=False)

        parentquery='parent_md5:'+md5
        md5query='md5:'+md5

        if md5query.endswith(" "):
            print colored.red("[-] Bit9 did not capture the MD5 :(\n")
        else:
            print colored.yellow("[*] Checking if Parent MD5 process in Carbon Black...")
            parentresult = cb.process_search(parentquery, sort='start desc')
            if parentresult['total_results']==0:
                print colored.cyan("[+] Not a Parent MD5 process")
            else:
                cbparentmd5url=parentmd5url+md5+"&sort=&rows=10&start=0"
                print colored.green("[+] Parent MD5 event found in Carbon Black.")
                print colored.cyan(cbparentmd5url)
            print colored.yellow("[*] Checking if MD5 seen in Carbon Black...")
            md5result = cb.process_search(md5query, sort='start desc')
            if md5result['total_results'] == 0:
                print colored.cyan("[+] Not seen in Carbon Black.")
            else:
                cbmd5url=md5url+md5+"&sort=&rows=10&start=0"
                print colored.green("[+] MD5 Found in CB.")
                print colored.cyan(cbmd5url)