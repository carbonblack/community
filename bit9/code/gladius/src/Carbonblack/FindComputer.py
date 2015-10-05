import requests
from clint.textui import colored
from Launch.Launch import Launch

class FindCBComputer(object):

    @staticmethod
    def Run(computername):
        launch=Launch()
        args=launch.get_args()
        cbserverurl,cbapitoken=launch.load_cb_config(args.configfile)

        headers = {"X-Auth-Token": cbapitoken}  
        resp = requests.get(cbserverurl+str("/api/v1/sensor?hostname="+str(computername)), headers=headers, verify=False)  
        return resp.json()