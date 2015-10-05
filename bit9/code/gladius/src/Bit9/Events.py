import requests,json

class Events(object):

	@staticmethod
	def Run(term, value, limit):
		authJson={
         'X-Auth-Token': "30FC583B-8D49-4EE9-B34C-D7612C82898C", 
         'content-type': 'application/json'
                      }
		serverurl="https://chimeraus.autodesk.com"+str("/api/bit9platform/v1/")
		eventurl=serverurl+"event"
		b9StrongCert=True
		r = requests.get(eventurl+"?q="+term+":"+value+"&limit="+limit+"&sort=receivedTimestamp%20DESC", headers=authJson, verify=b9StrongCert)
		r.raise_for_status()
		result = r.json()
		return result