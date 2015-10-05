import requests,json
from clint.textui import colored
from Launch.Launch import Launch

class FindB9Computer(object):

	@staticmethod
	def Run(computername):
		launch=Launch()
		args=launch.get_args()
		b9serverurl,b9apitoken=launch.load_b9_config(args.configfile)
		authJson={
		'X-Auth-Token': b9apitoken, 
		'content-type': 'application/json'
		}
		serverurl=b9serverurl+str("/api/bit9platform/v1/")
		computernameurl=serverurl+"computer?q=name:"
		computerurl=serverurl+"Computer/"
		b9StrongCert=True
		r = requests.get(computernameurl+computername, headers=authJson, verify=b9StrongCert)
		r.raise_for_status()
		result = r.json()
		return result