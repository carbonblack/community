import sys,requests,time,json
from clint.textui import colored

class Bit9(object):

    def __init__(self):

        self.b9StrongCert = True
        self.apitoken="YOUR-API-TOKEN-HERE"
        self.serverurl="YOUR-SERVER-URL-HERE.com/api/bit9platform/v1/"
        self.authJson={
         'X-Auth-Token': self.apitoken, 
         'content-type': 'application/json'
                      } 

        self.md5url = self.serverurl+"fileCatalog?q=md5:"
        self.fileruleurl = self.serverurl+"fileRule"
        self.computernameurl=self.serverurl+"computer?q=name:"
        self.computerurl=self.serverurl+"Computer/"
        self.pathnameurl=self.serverurl+"fileInstanceGroup?q=pathName:"

 
    def find_computer(self, computername):
        r = requests.get(self.computernameurl+"ADS\\"+computername, headers=self.authJson, verify=self.b9StrongCert)
        r.raise_for_status()
        result = r.json()
        return result


    def tag_computer(self, computername, description, computertag):
    	print colored.yellow("[*] Finding "+computername)
        result = self.find_computer(computername)
        computerid = str(result[0]['id'])
        print colored.green("[+] "+computername+" ID="+computerid)
        data = {'description':description, 'computerTag': computertag}
        print colored.yellow("[*] Tagging "+computername)
        r = requests.put(self.computerurl+computerid, json.dumps(data), headers=self.authJson, verify=self.b9StrongCert)
        r.raise_for_status()
        result = r.json()
        print colored.green("[+] Tag Succeeded! ...waiting...\n")
        time.sleep(.07)

    def change_policy(self, computername):
        result = self.find_computer(computername)
        computerid = str(result[0]['id'])

        data = {'policyId':7}

        r = requests.put(self.computerurl+computerid, json.dumps(data), headers=self.authJson, verify=self.b9StrongCert)
        r.raise_for_status()
        result = r.json()

def perform_b9_tagging(workstationdata):
    description=workstationdata.split("	")[4]+"\n"+workstationdata.split("	")[6]+"\n"+workstationdata.split("	")[5]+"\n"+workstationdata.split("	")[7]+"\n"+workstationdata.split("	")[8]+"\n"+workstationdata.split("	")[2]+"\n"+workstationdata.split("	")[10]+"\n"+workstationdata.split("	")[11]
    computertag=workstationdata.split("	")[0]+"#"+workstationdata.split("	")[9]
    bit9.tag_computer(bit9computers[workstationdata.split("\t")[1].lower()], description, computertag)


#take in a list of bit9 agent computer names and a tab delimited text file containing asset meta-data.  tag matching bit9 agents with meta-data for more granualr detail on an endpoint
if __name__ == '__main__':
	bit9computers = {}
	bit9=Bit9()

	for line in open(sys.argv[1]):
		bit9computers[line[3:].lower().rstrip()]=line.rstrip()

	for workstation in open(sys.argv[2]):
		if workstation.split("	")[1].lower() in bit9computers:
			print workstation.rstrip()
			perform_b9_tagging(workstation)

	print colored.green("[+] Congrats! We're all done tagging machines! :)")