import requests,json
from clint.textui import colored

class BanCertificate(object):

	@staticmethod
	def Run(hashstate):
		authJson={
		'X-Auth-Token': "30FC583B-8D49-4EE9-B34C-D7612C82898C", 
		'content-type': 'application/json'
		}
		serverurl="https://chimeraus.autodesk.com"+str("/api/bit9platform/v1/")
		certificateurl=serverurl+"publisher/"
		b9StrongCert=True
		print colored.yellow("[*] Banning certificate for "+hashstate[0]['publisher']+"...")
		data = {'publisherState': 3}
		r = requests.put(certificateurl+str(hashstate[0]['publisherId']), json.dumps(data), headers=authJson, verify=b9StrongCert)
		r.raise_for_status()      
		fileRule = r.json() 
		print colored.green("[+] "+hashstate[0]['publisher']+" certificate has been Banned!") 