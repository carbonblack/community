import requests,json
from clint.textui import colored

class BanHash(object):

	@staticmethod
	def Run(hashvalue,rulename):
		authJson={
		'X-Auth-Token': "30FC583B-8D49-4EE9-B34C-D7612C82898C", 
		'content-type': 'application/json'
		}
		serverurl="https://chimeraus.autodesk.com"+str("/api/bit9platform/v1/")
		fileruleurl = serverurl+"fileRule"
		b9StrongCert = True
		print colored.yellow("[*] Banning "+ hashvalue+"...")
		data = {'hash': hashvalue, 'fileState': 3, 'policyIds': '0', 'name': rulename}
		r = requests.post(fileruleurl, json.dumps(data), headers=authJson, verify=b9StrongCert)
		r.raise_for_status()      
		fileRule = r.json()
		try:
			print colored.green("[+] "+str(rulename)+" "+str(hashvalue)+" Banned!")
		except:
			print colored.yellow("[*] Can't print strange characters, need to learn 2 codec")
			pass