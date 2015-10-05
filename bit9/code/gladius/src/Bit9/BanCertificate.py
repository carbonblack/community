import requests,json
from clint.textui import colored
from Launch.Launch import Launch

class BanCertificate(object):

	@staticmethod
	def Run(hashstate):
		launch=Launch()
		args=launch.get_args()
		b9serverurl,b9apitoken=launch.load_b9_config(args.configfile)
		authJson={
		'X-Auth-Token': b9apitoken, 
		'content-type': 'application/json'
		}
		serverurl=b9serverurl+str("/api/bit9platform/v1/")
		b9StrongCert=True
		print colored.yellow("[*] Banning certificate for "+hashstate[0]['publisher']+"...")
		data = {'publisherState': 3}
		r = requests.put(certificateurl+str(hashstate[0]['publisherId']), json.dumps(data), headers=authJson, verify=b9StrongCert)
		r.raise_for_status()      
		fileRule = r.json() 
		print colored.green("[+] "+hashstate[0]['publisher']+" certificate has been Banned!") 