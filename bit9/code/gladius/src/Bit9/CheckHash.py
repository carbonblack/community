import requests,json
 
class CheckHash(object):

    @staticmethod
    def Run(hashtype,value):
        authJson={
         'X-Auth-Token': "30FC583B-8D49-4EE9-B34C-D7612C82898C", 
         'content-type': 'application/json'
                      }
        serverurl="https://chimeraus.autodesk.com"+str("/api/bit9platform/v1/")
        b9StrongCert=True
        md5url = serverurl+"fileCatalog?q=md5:"
        sha256url = serverurl+"fileCatalog?q=sha256:"

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