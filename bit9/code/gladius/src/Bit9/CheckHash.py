import requests,json
from Launch.Launch import Launch

class CheckHash(object):

    @staticmethod
    def Run(hashtype,value):
        launch=Launch()
        args=launch.get_args()
        b9serverurl,b9apitoken=launch.load_b9_config(args.configfile)
        authJson={
         'X-Auth-Token': b9apitoken, 
         'content-type': 'application/json'
                      }
        serverurl=b9serverurl+str("/api/bit9platform/v1/")
        md5url = serverurl+"fileCatalog?q=md5:"
        sha256url = serverurl+"fileCatalog?q=sha256:"
        b9StrongCert=True

        if hashtype=="md5":
            hashurl=md5url

        if hashtype=="sha1":
            hashurl=sha1url

        if hashtype=="sha256":
            hashurl=sha256url

        r = requests.get(hashurl+value, headers=authJson, verify=b9StrongCert)
        r.raise_for_status()
        result = r.json()
        return result