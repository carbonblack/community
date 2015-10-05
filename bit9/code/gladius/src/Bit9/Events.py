import requests,json
from Launch.Launch import Launch

class Events(object):

	@staticmethod
	def Run(term, value, limit):
		launch=Launch()
		args=launch.get_args()
		b9serverurl,b9apitoken=launch.load_b9_config(args.configfile)
		authJson={
         'X-Auth-Token': b9apitoken, 
         'content-type': 'application/json'
                      }
		serverurl=b9serverurl+str("/api/bit9platform/v1/")
		eventurl=serverurl+"event"
		b9StrongCert=True
		r = requests.get(eventurl+"?q="+term+":"+value+"&limit="+limit+"&sort=receivedTimestamp%20DESC", headers=authJson, verify=b9StrongCert)
		r.raise_for_status()
		result = r.json()
		return result